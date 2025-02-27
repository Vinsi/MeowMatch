//
//  Router.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import SwiftUI

final class Router: ObservableObject {

    public enum Destination: Codable, Hashable {
      //  case search
      //  case list
        case details(breed: CatBreed)
    }

    // Define top-level tabs
    public enum Tab: String, CaseIterable {
        case list
        case search

    }

    @Published var navPath = NavigationPath()
    @Published var selectedTab: Tab = .list

    func navigate(to destination: Destination) {
        navPath.append(destination)
    }

    func navigateBack() {
        navPath.removeLast()
    }

    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}

extension Router.Destination {

    @ViewBuilder
    var toView: some View {
        switch self {
        case .details(let cat):
            let network = NetworkProcesserTypeImpl()
            let environment = AppEnvironment.shared
            let service = CatImageServiceTypeImpl(network: network, baseURLProvider: environment)
            let viewModel = CatDetailViewModel(service: service,
                                               breed: cat)
            CatDetailView(viewModel: viewModel)
        }
    }

}

extension View {
    func navigateUsingRouter() -> some View {
        navigationDestination(for: Router.Destination.self) { destination in
            destination.toView
        }
    }


}
