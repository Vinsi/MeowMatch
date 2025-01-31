//
//  RequestBuilder.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation

final class RequestBuilder {

    private var body: Data?

    private var baseURL: String = ""

    private var path: String = ""

    private var method: HTTPMethod = .get

    private var headers: [String: String] = [:]

    private var queryParameters: [KeyValuePair] = []

    @discardableResult func set(baseURL: String) -> Self {
        self.baseURL = baseURL
        return self
    }

    @discardableResult func set(path: String) -> Self {
        self.path = path
        return self
    }

    @discardableResult func set(method: HTTPMethod) -> Self {
        self.method = method
        return self
    }

    @discardableResult func set(header: [String: String]) -> Self {
        headers = header
        return self
    }

    @discardableResult func addHeader(key: String, value: String) -> Self {
        headers[key] = value
        return self
    }

    @discardableResult func set(query: [KeyValuePair]) -> Self {
        queryParameters = query
        return self
    }

    @discardableResult func addQuery(query: KeyValuePair) -> Self {
        queryParameters += [query]
        return self
    }

    @discardableResult func set(body: Data) -> Self {
        self.body = body
        return self
    }

    func makeUrlRequest() throws -> URLRequest {

        var components = URLComponents(string: ["https:/", baseURL, path].joined(separator: "/"))
        components?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        urlRequest.timeoutInterval = 20
        return urlRequest
    }
}

enum HTTPMethod: String {
    case get = "GET"
}

struct KeyValuePair {
    let key: String
    let value: String
}
