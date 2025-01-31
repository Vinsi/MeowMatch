//
//  BreadSearchServiceType.swift
//  MeowMatch
//
//  Created by Vinsi.
//

protocol BreadSearchServiceType {
    func search(query: String) async throws -> [CatBreed]
}

struct BreadSearchServiceImpl: BreadSearchServiceType {
    let network: NetworkProcesserType
    let baseURLProvider: BaseURLProvider

    func search(query: String) async throws -> [CatBreed] {
        defer {
            logNet.logI("search.query:->\(query)-completed")
        }
        logNet.logW("search.query:->\(query)")
        guard query.isNotEmpty else {
            return []
        }
        return try await network.request(from: BreedSearchEndpoint(baseURL: baseURLProvider.baseURL, searchText: query))
    }
}
