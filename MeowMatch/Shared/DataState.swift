//
//  DataState.swift
//  MeowMatch
//
//  Created by Vinsi.
//

enum DataState<T, E: Error>: Equatable {

    static func == (lhs: DataState<T, E>, rhs: DataState<T, E>) -> Bool {
        // Ignoring case for data T and E
        switch (lhs, rhs) {
        case (.notStarted, .notStarted),
             (.fetching, .fetching):
            return true
        case (.success, .success),
             (.failure, .failure):
            return true // ✅ Same case, but ignores `T` and `E` values
        default:
            return false
        }
    }

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

    var errorMessage: String? {
        switch self {
        case .failure(let value):
            value.localizedDescription
        default: nil
        }
    }
}
