//
//  HomeServiceType.swift
//  MeowMatch
//
//  Created by Vinsi.
//
let logNet = LogWriter(.init(value: "Net"))
import Foundation

protocol BreedListServiceType {
    func getAll(page: Int, limit: Int) async throws -> [CatBreed]
}

struct BreedListServiceImpl: BreedListServiceType {
    let network: NetworkProcesserType
    let baseURLProvider: BaseURLProvider

    func getAll(page: Int, limit: Int) async throws -> [CatBreed] {
        defer {
            logNet.logI("getAll.breed.completed")
        }
        logNet.logI("getAll.breed.started")
        let endPoint = BreedEndPoint(baseURL: baseURLProvider.baseURL, page: page, limit: limit)
        return try await network.request(from: endPoint)
    }
}
