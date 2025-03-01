//
//  HomeServiceType.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation

/// 🐱 **Protocol for Fetching Cat Breeds**
/// - Defines a contract for retrieving a list of cat breeds.
/// - Supports pagination with `page` and `limit` parameters.
///

protocol BreedListServiceType {
    /// Fetches all cat breeds from the API.
    /// - Parameters:
    ///   - page: The current page number for pagination.
    ///   - limit: The number of breeds to fetch per request.
    /// - Returns: An array of `CatBreed` objects.
    /// - Throws: An error if the network request fails.
    func getAll(page: Int, limit: Int) async throws -> [CatBreed]
}

struct BreedListServiceImpl: BreedListServiceType {
    let baseURLProvider: BaseURLProvider = AppEnvironment.shared
    var network: NetworkProcesserType

    func getAll(page: Int, limit: Int) async throws -> [CatBreed] {
        let endPoint = BreedEndPoint(baseURL: baseURLProvider.baseURL, page: page, limit: limit)
        return try await network.request(from: endPoint)
    }
}
