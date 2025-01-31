//
//  SearchView.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var environment: AppEnvironment
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject var viewModel: SearchViewModel
    @State var hasError = false

    var body: some View {
        NavigationView {
            ZStack {
                AppBackground()
                VStack(alignment: .leading) {
                    SearchBarView(
                        searchText: $viewModel.searchText,
                        isLoading: $viewModel.isLoading,
                        placeholder: Localized.searchBreedPlaceholder,
                        theme: themeManager.currentTheme
                    )
                    .padding(.top, themeManager.currentTheme.spacing.medium)

                    if case .success(let cats) = viewModel.dataState {
                        CatListView(
                            breeds: cats,
                            onTap: viewModel.onSelect(_:)
                        )
                    }

                    if case .fetching = viewModel.dataState {
                        ProgressView().padding()
                    }

                    Spacer()
                }

                .navigationBarTitleDisplayMode(.inline)
                .task {
                    viewModel.configure(router: router)
                }
            }
        }

        .tabItem {
            Label(
                Localized.searchTitle,
                systemImage: themeManager.currentTheme.images.searchSystemIcon
            )
        }
        .onChange(of: viewModel.dataState, perform: { newValue in
            if case .failure = newValue {
                hasError = true
            } else {
                hasError = false
            }
        })
        .errorAlert(
            isPresented: $hasError,
            errorMessage: viewModel.dataState.errorMessage,
            retryAction: viewModel.retry
        )
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(searchService: MockBreadSearchServiceType(onExecute: {
        Array([.mock(), .mock(), .mock()].prefix((0 ... 2).randomElement()!))
    })))
    .environmentObject(AppEnvironment.shared)
    .environmentObject(Router())
    .environmentObject(ThemeManager())
}
