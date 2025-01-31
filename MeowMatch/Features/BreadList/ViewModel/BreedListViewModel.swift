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
        Task {
            await pagingManager.fetchNextPage()
        }
    }

    func initialFetch() {
        guard viewData.isEmpty else {
            return
        }
        pagingManager.reset()
        Task {
            await pagingManager.fetchNextPage()
        }
    }

    func loadMore() {
        log.logI("load.more")
        Task {
            await pagingManager.fetchNextPage()
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

protocol ListViewDataType {
    var breedID: String { get }
    var breedName: String { get }
    var breedOrigin: String { get }
    var breedTemperament: String { get }
    var breedDescription: String { get }
    var breedImageURL: URL? { get }
    var breedLifeSpan: String { get }
}

extension CatBreed: ListViewDataType {
    var breedID: String {
        id ?? ""
    }

    var breedName: String {
        name ?? ""
    }

    var breedOrigin: String {
        origin ?? ""
    }

    var breedTemperament: String {
        temperament ?? ""
    }

    var breedDescription: String {
        description ?? ""
    }

    var breedImageURL: URL? {
        imageURL
    }

    var breedLifeSpan: String {
        lifeSpan ?? ""
    }
}
