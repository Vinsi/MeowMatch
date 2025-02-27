//
//  SearchViewModel.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation

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
    private let debouncer = Debouncer<String>(delay: 0.3)
    private var router: Router?

    init(searchService: BreadSearchServiceType) {
        self.searchService = searchService
    }

    func search(_ query: String) {
        log.logI("search.started")

        debouncer.schedule(query) { [weak self] in
            do {
                await MainActor.run { [weak self] in
                    self?.isLoading = true
                }

                let list = try await self?.searchService.search(query: query) ?? []
                guard query == self?.debouncer.lastInput else {
                    log.logE("search.removed.stale.for[\(query)].response", .failure)
                    return
                }

                await MainActor.run { [weak self] in
                    self?.isLoading = false
                    log.logI("search.finished", .success)
                    self?.dataState = .success(list)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    log.logI("search.finished", .failure)
                    self?.dataState = .success([])
                }
            }
        }
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
