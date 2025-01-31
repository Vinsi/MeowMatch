//
//  URLDataTaskProvider.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation

protocol URLDataTaskProvider {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLDataTaskProvider {}
