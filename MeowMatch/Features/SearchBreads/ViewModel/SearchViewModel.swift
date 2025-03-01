//
//  SearchViewModel.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation
@MainActor
final class SearchViewModel: ObservableObject {
    @Published private(set) var dataState: DataState<[ListViewDataType], any Error> = .notStarted
    @Published var isLoading: Bool = false
    @Published var searchText: String = "" {
        didSet {
            log.logI("search.text.query?\(searchText)")
            search(searchText)
        }
    }

    private let searchService: BreadSearchServiceType
    private let debouncer = AsyncDebouncer<String, [CatBreed] >(delay: 0.3)
    private var router: Router?

    init(searchService: BreadSearchServiceType) {
        self.searchService = searchService

        debouncer.config { [weak self] in
            self?.isLoading = $0
        }

        debouncer.config(operation: { [weak self] query in
            let list = try await self?.searchService.search(query: query) ?? []
            return list
        })
    }

    func search(_ query: String) {
        log.logI("search.started")
        debouncer.debounce(input: query) { [weak self] result in
            switch result {
            case .success(let breeds):
                self?.dataState = .success(breeds)
            case .failure(let error):
                self?.dataState = .failure(error)
            }
        }
    }

    @MainActor
    func loader(isShowing: Bool = true) {
        self.isLoading = isLoading
    }


    func retry() {
        search(searchText)
    }

    func configure(router: Router) {
        self.router = router
    }

    func onSelect(_ viewData: ListViewDataType) {
        guard let breed = viewData as? CatBreed else {
            return
        }
        router?.navigate(to: .details(breed: breed))
    }
}
