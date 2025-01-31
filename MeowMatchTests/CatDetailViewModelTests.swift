//
//  CatDetailViewModelTests.swift
//  MeowMatch
//
//  Created by Vinsi.
//


import XCTest
@testable import MeowMatch // Replace with your module name

struct MockNetworkProcessor: NetworkProcesserType {

    var mockResponse: Any? // Holds the mock response
    var shouldThrowError: Bool = false // Simulates error scenarios
    var errorToThrow: Error = NSError(domain: "MockError", code: 500) // Default error

    func request<T>(from endpoint: T) async throws -> T.Response where T: EndPointType {
        if shouldThrowError {
            throw errorToThrow
        }

        guard let response = mockResponse as? T.Response else {
            throw NSError(domain: "MockError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Invalid mock response type"])
        }

        return response
    }
}

struct MockBaseURLProvider: BaseURLProvider {
    var baseURL: String = ""
}

extension CatImage {
    static func mock(id: String = "5iYq9NmT1", url: String = "https://cdn2.thecatapi.com/images/5iYq9NmT1.jpg", width: Int = 800, height: Int = 600) -> CatImage {
       CatImage(
            id: id,
            url: url,
            width: width,
            height: height
        )
    }

    static func mock1(id: String = "vJB8rwfdX", url: String = "https://cdn2.thecatapi.com/images/vJB8rwfdX.jpg", width: Int = 1600, height: Int = 1067) -> CatImage {
       CatImage(
            id: id,
            url: url,
            width: width,
            height: height
        )
    }
}

extension [CatImage] {
    static var mocks: [CatImage] {
        [.mock(), .mock1()]
    }
}

final class CatDetailViewModelTests: XCTestCase {

    class MockCatImageService: CatImageServiceType {
        var shouldThrowError = false
        func getImages(id: String) async throws -> [CatImage] {
            if shouldThrowError { throw NSError(domain: "TestError", code: 500) }
            return .mocks
        }
    }

    // MARK: - Properties
    
    var viewModel: CatDetailViewModel!
    var mockNetwork: MockNetworkProcessor!
    var mockBaseURLProvider: MockBaseURLProvider!
    var mockBreed: CatBreed!
    var mockImageService: MockCatImageService!

    override func setUp() {
        super.setUp()
        mockNetwork = MockNetworkProcessor()
        mockBaseURLProvider = MockBaseURLProvider()
        mockBreed = .mock()
        viewModel = CatDetailViewModel(service: MockCatImageService(), breed: mockBreed)
    }

    override func tearDown() {
        viewModel = nil
        mockNetwork = nil
        mockBaseURLProvider = nil
        mockBreed = nil
        super.tearDown()
    }

    // MARK: - Tests
    
    func testViewModel_Initialization() {
        XCTAssertEqual(viewModel.breed.id, "abys")
        XCTAssertEqual(viewModel.breed.name, "Abyssinian")
    }
    
    func testFetchImages_Success() async {
        let expectation = XCTestExpectation(description: "Fetching images should update sections")
        
        viewModel.fetchImages()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if case .success(let sections) = self.viewModel.sections {
                XCTAssertEqual(sections.count, 4) // Ensure 4 sections are created
                guard case .images = sections[0] else {
                    XCTFail("image mismatch")
                    return
                }
                guard case .description = sections[1] else {
                    XCTFail("description mismatch")
                    return
                }
                guard case .attributes = sections[2] else {
                    XCTFail("attributes mismatch")
                    return
                }
                guard case .links = sections[3] else {
                    XCTFail("links mismatch")
                    return
                }
                expectation.fulfill()
            } else {
                XCTFail("Sections were not updated correctly")
            }
        }
        
        await fulfillment(of: [expectation], timeout: 3.0)
    }


}
