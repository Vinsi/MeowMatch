//
//  DataState.swift
//  MeowMatch
//
//  Created by Vinsi.
//

enum DataState<T, E: Error> {
    case notStarted
    case fetching
    case success(T)
    case failure(E)

    var isCompleted: Bool {
        switch self {
        case .failure, .success: true
        default: false
        }
    }

    var value: T? {
        switch self {
        case .success(let value): value
        default: nil
        }
    }
}
