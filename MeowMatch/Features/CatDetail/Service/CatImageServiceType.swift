//
//  CatImageServiceType.swift
//  MeowMatch
//
//  Created by Vinsi.
//

protocol CatImageServiceType {
    func getImages(id: String) async throws -> [CatImage]
}

struct CatImageServiceTypeImpl: CatImageServiceType {

    let network: NetworkProcesserType
    let baseURLProvider: BaseURLProvider

    func getImages(id: String) async throws -> [CatImage] {
        try await network.request(from: CatImagesEndpoint(baseURL: baseURLProvider.baseURL, id: id))
    }
}
