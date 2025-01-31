//
//  PagingManager.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation

protocol Paginatable: AnyObject {
    associatedtype DataType
    var pageIsLoading: Bool { get set }
    func fetchPage(page: Int, size: Int) async throws -> [DataType]
    func add(items: [DataType])
    func reset()
}

final class PagingManager<T: Paginatable> {
    private weak var viewModel: T?
    private var startingPage: Int
    private(set) var currentPage: Int
    private(set) var hasMorePages: Bool = true
    private var pageSize: Int

    init(viewModel: T, startingPage: Int = 0, pageSize: Int = 10) {
        self.viewModel = viewModel
        self.startingPage = startingPage
        self.pageSize = pageSize
        currentPage = startingPage
    }

    func reset() {
        viewModel?.pageIsLoading = false
        currentPage = startingPage
        hasMorePages = true
        viewModel?.reset()
    }

    func fetchNextPage() async throws {
        guard let viewModel, !viewModel.pageIsLoading, hasMorePages else {
            logPaging.logW("page.finished.exiting", .success)
            return
        }
        await isFetching(true)
        let newItems = try await viewModel.fetchPage(page: currentPage, size: pageSize)
        hasMorePages = newItems.count == pageSize
        await MainActor.run {
            viewModel.add(items: newItems)
        }
        await isFetching(false)
        currentPage += 1
    }

    @MainActor
    private func isFetching(_ status: Bool) {
        viewModel?.pageIsLoading = status
    }
}
