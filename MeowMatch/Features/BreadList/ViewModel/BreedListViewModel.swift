//
//  BreedListViewModel.swift
//  MeowMatch
//
//  Created by Vinsi.
//
import Foundation

/// 🐱 **ViewModel for Managing Cat Breed List**
/// - Handles data fetching, pagination, and error states.
/// - Uses `PagingManager` to support paginated API calls.

final class BreedListViewModel: ObservableObject {

    /// 🏗 **Published Properties for UI Updates**
    @Published var pageIsLoading = false
    @Published var viewData: [ListViewDataType] = []
    @Published var isError: Bool = false
    private(set) var errorMessage: String?

    /// 📌 **Dependencies**
    private var router: Router?
    private let listService: BreedListServiceType

    /// 📖 **Pagination Setup**
    private let pageSize = 10
    lazy var pagingManager = PagingManager<BreedListViewModel>(viewModel: self)

    init(service: BreedListServiceType) {
        listService = service
    }

    func loadFromStart() {
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
                self?.errorMessage = error.localizedDescription
                await self?.showError()
            }
        }
    }

    /// 🔄 **Retry Fetching After Failure**
    /// - Resets loading state and attempts to fetch again.
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

    /// 📦 **Fetches a Page of Cat Breeds**
    /// - Parameters:
    ///   - page: Page number to fetch.
    ///   - size: Number of items per page.
    /// - Returns: A list of `CatBreed` objects.
    /// - Throws: If the request fails.
    func fetchPage(page: Int, size: Int) async throws -> [CatBreed] {
        return try await listService.getAll(page: page, limit: size)
    }

    /// ➕ **Adds New Items to ViewData**
    /// - Appends fetched breeds to the list.
    func add(items: [CatBreed]) {
        viewData.append(contentsOf: items)
    }

    func reset() {
        viewData.removeAll()
    }
}
