//
//  BreedListView.swift
//  MeowMatch
//
//  Created by Vinsi.
//
let logPaging = LogWriter(.init(value: "List"))
let log = LogWriter(.init(value: "Meow"))
let logNet = LogWriter(.init(value: "Net"))

import SwiftUI

struct BreedListView: View {
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var environment: AppEnvironment
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject var viewModel: BreedListViewModel = BreedListViewModel(
        service: BreedListServiceImpl(network: NetworkProcesserTypeImpl())
    )
    var onTap: ((ListViewDataType) -> Void)?


    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .top) {
                    CatListView(
                        breeds: viewModel.viewData,
                        onTap: viewModel.onSelect(_:),
                        onAppear5thLastElement: { [weak viewModel] in
                            viewModel?.loadMore()
                        }
                    )

                    if viewModel.pageIsLoading {
                        HUDLoaderView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                }
                .background(AppBackground())
            }
            .refreshable {
                viewModel.loadFromStart()
            }
            .navigationTitle(Localized.breedTitle)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                viewModel.configure(router: router)
                viewModel.initialFetch()
            }
            .onDisappear {}
        }
        .errorAlert(
            isPresented: $viewModel.isError,
            errorMessage: viewModel.errorMessage,
            retryAction: viewModel.retry
        )

        .tabItem {
            Label(Localized.breedTitle,
                  systemImage: themeManager.currentTheme.images.listSystemIcon)
        }
    }
}

#Preview {
    BreedListView(viewModel: BreedListViewModel(service: MockBreadListServiceType()))
        .environmentObject(AppEnvironment.shared)
        .environmentObject(Router())
        .environmentObject(ThemeManager())
}
