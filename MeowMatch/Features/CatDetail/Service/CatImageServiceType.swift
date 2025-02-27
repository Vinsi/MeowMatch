//
//  CatImageServiceType.swift
//  MeowMatch
//
//  Created by Vinsi.
//

/// 🐱 **Protocol for Fetching Cat Images**
/// - Defines a contract for retrieving cat images by breed ID.
protocol CatImageServiceType {
    /// 📸 **Fetches Cat Images from API**
    /// - Parameter id: The unique identifier of the cat breed.
    /// - Returns: An array of `CatImage` objects.
    /// - Throws: If the network request fails.
    func getImages(id: String) async throws -> [CatImage]
}

struct CatImageServiceTypeImpl: CatImageServiceType {

    let network: NetworkProcesserType
    let baseURLProvider: BaseURLProvider

    func getImages(id: String) async throws -> [CatImage] {
        try await network.request(from: CatImagesEndpoint(baseURL: baseURLProvider.baseURL, id: id))
    }
}
