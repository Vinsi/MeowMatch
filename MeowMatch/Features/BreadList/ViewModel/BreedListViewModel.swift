//
//  BreedListViewModel.swift
//  MeowMatch
//
//  Created by Vinsi.
//
import Foundation

final class BreedListViewModel: ObservableObject {

    @Published var pageIsLoading = false
    @Published var viewData: [ListViewDataType] = []
    @Published var isError: Bool = false
    private var router: Router?
    private let listService: BreedListServiceType
    private let pageSize = 10
    lazy var pagingManager = PagingManager<BreedListViewModel>(viewModel: self)

    init(service: BreedListServiceType) {
        listService = service
    }

    func loadFromStart() {
        log.logI("load.start")
        pagingManager.reset()
        Task { [weak self] in
            self?.fetch()
        }
    }

    func initialFetch() {
        guard viewData.isEmpty else {
            return
        }
        pagingManager.reset()
        Task { [weak self] in
            self?.fetch()
        }
    }

    func loadMore() {
        log.logI("load.more")
        Task { [weak self] in
            self?.fetch()
        }
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

    private func fetch() {
        Task { [weak self] in
            do {
                await self?.hideError()
                try await self?.pagingManager.fetchNextPage()
            } catch {
                await self?.showError()
            }
        }
    }

    func retry() {
        pageIsLoading = false
        Task { [weak self] in
            self?.fetch()
        }
    }

    @MainActor
    private func showError() {
        isError = true
    }

    @MainActor
    private func hideError() {
        isError = false
    }
}

extension BreedListViewModel: Paginatable {
    func fetchPage(page: Int, size: Int) async throws -> [CatBreed] {
        logPaging.logI("loadPaging page: \(page) - \(size)")
        return try await listService.getAll(page: page, limit: size)
    }

    func add(items: [CatBreed]) {
        viewData.append(contentsOf: items)
    }

    func reset() {
        viewData.removeAll()
    }
}
