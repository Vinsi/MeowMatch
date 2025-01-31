//
//  RequestBuilder+App.swift
//  MeowMatch
//
//  Created by Vinsi.
//

extension RequestBuilder {

    @discardableResult
    func add(baseURL: String) -> Self {
        set(baseURL: baseURL)
        return self
    }

    @discardableResult
    func add(token: String) -> Self {
        addHeader(key: "x-api-key", value: token)
        return self
    }
}
