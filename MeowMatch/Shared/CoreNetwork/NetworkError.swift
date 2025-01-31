//
//  NetworkError.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation

enum NetworkError: Error {

    case invalidURL
    case invalidResponse
    case unexpectedResponse(statusCode: Int, message: String = "")
    case decodingError(message: String)
    case unknown
    case disconnected
}

extension NetworkError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return Localized.Error.malformedURL
        case .decodingError(let message):
            return Localized.Error.failedToDecode(message: message)
        case .unknown:
            return Localized.Error.unknown
        case .disconnected, .unexpectedResponse, .invalidResponse:
            return Localized.Error.disconnected
        }
    }
}

func undefined<T>() -> T {
    fatalError("undefined")
}
