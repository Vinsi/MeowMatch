//
//  CatDetailView.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import SwiftUI

struct CatDetailView: View {

    @StateObject var viewModel: CatDetailViewModel
    @EnvironmentObject var environment: AppEnvironment
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.presentationMode) var presentationMode
    @State var hasError: Bool = false

    var theme: Theme {
        themeManager.currentTheme
    }

    @ViewBuilder
    private func attributeSection(_ title: String, _ attributes: [(title: String, value: String)]) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.medium) {
            Text(title)
                .font(theme.typography.title)
                .fontWeight(.semibold)

            ForEach(attributes, id: \.title) { attribute in
                AttributeRow(attribute: attribute.title, value: attribute.value)
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func descriptions(_ title: String, _ description: String) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.medium) {
            Text(title)
                .font(theme.typography.title)
                .fontWeight(.bold)

            Text(description)
                .font(theme.typography.body)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func moreLinks(_ title: String, _ links: [(title: String, url: URL)]) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.medium) {
            Text(title)
                .font(theme.typography.title)
                .fontWeight(.semibold)
            ForEach(links, id: \.url.absoluteString) { link in
                Link(link.title, destination: link.url)
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func createSections(sections: [DetailSection]) -> some View {
        ForEach(sections) { section in
            switch section {
            case .images(let imageUrls):
                CatImageCarousel(images: imageUrls, theme: themeManager.currentTheme)

            case .attributes(let title, let attributes):
                attributeSection(title, attributes)

            case .description(let title, let description):
                descriptions(title, description)

            case .links(let title, let links):
                moreLinks(title, links)
            }
        }
    }

    @ToolbarContentBuilder
    private func toolBar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(
                action: {
                    presentationMode.wrappedValue.dismiss()
                },
                label: {
                    HStack {
                        Image(themeManager.currentTheme.images.backIcon)
                    }
                }
            )
        }
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: themeManager.currentTheme.spacing.medium) {
                    switch viewModel.sections {
                    case .success(let sections):
                        createSections(sections: sections)
                    default:
                        EmptyView()
                    }
                }
                .padding(.vertical)
            }
            .background {
                AppBackground().scaledToFill().ignoresSafeArea(edges: .bottom)
            }
            .task {
                viewModel.fetchImages()
            }
            .onDisappear {
                hasError = false
            }

            if case .fetching = viewModel.sections {
                HUDLoaderView()
            }
        }

        .navigationTitle(Localized.detailTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            toolBar()
        }
        .onChange(of: viewModel.sections, perform: { newValue in
            if case .failure = newValue {
                hasError = true
            } else {
                hasError = false
            }
        })
        .errorAlert(
            isPresented: $hasError,
            errorMessage: viewModel.sections.errorMessage,
            retryAction: viewModel.fetchImages
        )
    }
}

struct AttributeRow: View {
    let attribute: String
    @EnvironmentObject private var theme: ThemeManager
    let value: String?

    var body: some View {
        HStack {
            Text(attribute)
                .font(theme.currentTheme.typography.mediumTitle)
            Spacer()
            Text(value ?? "")
                .font(theme.currentTheme.typography.mediumTitle)
                .multilineTextAlignment(.trailing)
                .foregroundColor(theme.currentTheme.colors.primary)
        }
    }
}

struct AppBackground: View {
    @EnvironmentObject var themeManager: ThemeManager
    var body: some View {
        Image(themeManager.currentTheme.images.pattern)
            .resizable(resizingMode: .tile)
            .opacity(0.1)
    }
}

extension View {

    func errorAlert(
        isPresented: Binding<Bool>,
        errorMessage: String?,
        retryAction: @escaping () -> Void
    ) -> some View {
        alert(
            Localized.ErrorAlert.title,
            isPresented: isPresented,
            presenting: errorMessage
        ) { _ in
            Button(Localized.ErrorAlert.retry, action: retryAction)
        } message: { error in
            Text(error)
        }
    }
}
