//
//  Environment.swift
//  MeowMatch
//
//  Created by Vinsi.
//

protocol BaseURLProvider {
    var baseURL: String { get }
}

protocol TokenProvider {
    var token: String { get }
}

import Foundation
import UIKit

// MARK: - Environment

final class AppEnvironment: ObservableObject, BaseURLProvider, TokenProvider {
    static let shared = AppEnvironment()

    private(set) lazy var scheme: Scheme = {
        switch Bundle.main.getAppConfig(for: .scheme) {
        case "PROD": .production
        case "STAG": .staging
        default: .development
        }
    }()

    enum Scheme {
        case staging
        case development
        case production
    }

    private init() {}

    var isProduction: Bool {
        scheme == .production
    }

    var baseURL: String {
        Bundle.main.getAppConfig(for: .baseURL) ?? ""
    }

    var token: String {
        Bundle.main.getAppConfig(for: .token) ?? ""
    }
}
