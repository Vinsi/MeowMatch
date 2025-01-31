//
//  PagingManagerTests.swift
//  MeowMatch
//
//  Created by Vinsi.
//


import XCTest

@testable import MeowMatch

final class PagingManagerTests: XCTestCase {
    class MockPaginatable: Paginatable {
        func add(items: [String]) {
            pagedItems.append(contentsOf: items)
        }
        
        func reset() {
            pagedItems.removeAll()
        }
        
        typealias DataType = String
        
        var pagedItems: [String] = []
        var pageIsLoading: Bool = false
        var totalItems: Int
        var fetchError: Error?
        
        init(totalItems: Int, fetchError: Error? = nil) {
            self.totalItems = totalItems
            self.fetchError = fetchError
        }
        
        func fetchPage(page: Int, size: Int) async throws -> [String] {
            if let fetchError = fetchError {
                throw fetchError
            }
            
            let start = page * size
            let end =  min((start + size),totalItems)
            return (start..<end).map { "Item \($0)" }
        }
    }
    
    func testInitialization() {
        let mockViewModel = MockPaginatable(totalItems: 20)
        let pagingManager = PagingManager(viewModel: mockViewModel, startingPage: 0)

        XCTAssertEqual(pagingManager.currentPage, 0)
        XCTAssertTrue(pagingManager.hasMorePages)
    }
    
    func testReset() {
        let mockViewModel = MockPaginatable(totalItems: 30)
        let pagingManager = PagingManager(viewModel: mockViewModel, startingPage: 0)
        
        Task {
            try await pagingManager.fetchNextPage()
            pagingManager.reset()
            
            XCTAssertFalse(mockViewModel.pageIsLoading)
            XCTAssertEqual(pagingManager.currentPage, 0)
            XCTAssertTrue(pagingManager.hasMorePages)
            XCTAssertEqual(mockViewModel.pagedItems.count, 0)
        }
    }
    
    func testFetchNextPage_Success() async throws  {
        let mockViewModel = MockPaginatable(totalItems: 10)
        let pagingManager = PagingManager(viewModel: mockViewModel, startingPage: 0)

        try await pagingManager.fetchNextPage()

        XCTAssertEqual(mockViewModel.pagedItems.count, 10) // Page size is 10
        XCTAssertEqual(pagingManager.currentPage, 1)
    }
    
    func testFetchNextPage_StopsWhenLoading() async throws  {
        let mockViewModel = MockPaginatable(totalItems: 3)
        let pagingManager = PagingManager(viewModel: mockViewModel, startingPage: 0)

        mockViewModel.pageIsLoading = true // Simulate loading state
        try await pagingManager.fetchNextPage()

        XCTAssertEqual(mockViewModel.pagedItems.count, 0) // No fetch should occur
    }
    
    func testFetchNextPage_ErrorHandling() async throws  {
        enum MockError: Error { case fetchFailed }
        
        let mockViewModel = MockPaginatable(totalItems: 3, fetchError: MockError.fetchFailed)
        let pagingManager = PagingManager(viewModel: mockViewModel, startingPage: 0)

        try await pagingManager.fetchNextPage()

        XCTAssertEqual(mockViewModel.pagedItems.count, 0) // Should not add items
        XCTAssertEqual(pagingManager.currentPage, 0) // Page should not advance
    }
    
    func testHasMorePages_FetchStops() async throws  {
        let mockViewModel = MockPaginatable(totalItems: 12) // Only one page
        let pagingManager = PagingManager(viewModel: mockViewModel, startingPage: 0)

        try await pagingManager.fetchNextPage()
        try await pagingManager.fetchNextPage() // Second fetch should not work

        XCTAssertEqual(mockViewModel.pagedItems.count, 12) // Only one page should be loaded
        XCTAssertFalse(pagingManager.hasMorePages) // No more pages left
    }
}
