//
//  TokenProvider.swift
//  MeowMatch
//
//  Created by Vinsi on 31/01/2025.
//

/// 🔐 **Token Provider**
/// Provides authentication token for API requests.
protocol TokenProvider {
    var token: String { get }
}
