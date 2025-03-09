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
    let baseURLProvider: BaseURLProvider = AppEnvironment.shared

    func search(query: String) async throws -> [CatBreed] {
        defer {
            log.logI("search.query:->['\(query)'].completed")
        }
        log.logW("search.query:->['\(query)'].started")
        guard query.isNotEmpty else {
            return []
        }
        return try await network.request(from: BreedSearchEndpoint(baseURL: baseURLProvider.baseURL, searchText: query))
    }
}

struct MockBreadSearchServiceImpl: BreadSearchServiceType {
    let dictionary: [String: [CatBreed]]
    func search(query: String) async throws -> [CatBreed] {
        dictionary[query] ?? []
    }
}
