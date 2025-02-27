//
//  NetworkProcesserType.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation

protocol NetworkProcesserType {
    func request<T>(from endpoint: T) async throws -> T.Response where T: EndPointType
}

struct NetworkProcesserTypeImpl: NetworkProcesserType {
    let cache: GeneralCache<String, Data>
    let decoder: JSONDecoder
    let urlTaskProvider: URLDataTaskProvider

    init(
        cacheProvider: GeneralCache<String, Data> = CacheManager.shared.dataCache,
        decoder: JSONDecoder = JSONDecoder(),
        urlTaskProvider: URLDataTaskProvider = URLSession.shared
    ) {
        self.decoder = decoder
        self.urlTaskProvider = urlTaskProvider
        cache = cacheProvider
    }

    func request<T>(from endpoint: T) async throws -> T.Response where T: EndPointType {

        let request = try endpoint.request.makeUrlRequest()
        guard let cacheKey = request.url?.absoluteString else {
            throw NetworkError.invalidURL
        }

        if let cachedData = await cache.getValue(forKey: cacheKey) {
            logNet.logW("network.from.cache[\(request.url?.absoluteString ?? "" )]")
            return try decoder.decode(T.Response.self, from: cachedData)
        } else {
            let request = try endpoint.request.makeUrlRequest()
            logNet.logI("network.started[\(request.url?.absoluteString ?? "" )]")
            let response = try await urlTaskProvider.data(for: request)
            logNet.logI("network.completed[\(request.url?.absoluteString ?? "" )]",.success)
            let responseModel =  try extractResponse(response, type: T.Response.self)
            await cache.setValue(response.0, forKey: cacheKey)
            return responseModel
        }
    }

    func extractResponse<R>(_ networkResponse: (Data, URLResponse), type: R.Type) throws -> R where R: Decodable {
        let (data, response) = networkResponse
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.invalidResponse
        }
        switch statusCode {
        case 200 ... 299:
            let decodedResponse = try decoder.decode(R.self, from: data)
            return decodedResponse
        case 400 ... 499:
            throw NetworkError.unexpectedResponse(statusCode: statusCode, message: "Client Error")
        case 500 ... 599:
            throw NetworkError.unexpectedResponse(statusCode: statusCode, message: "Server Error")
        default:
            throw NetworkError.unexpectedResponse(statusCode: statusCode, message: "Unknown Error")
        }
    }
}
