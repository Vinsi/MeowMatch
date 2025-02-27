//
//  Environment.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation
import UIKit

// MARK: - **App Environment Manager**

/// 🌍 **Singleton Class for Managing Environment Variables**
/// - Implements `BaseURLProvider` & `TokenProvider`
/// - Loads values from the app's configuration (Info.plist )
/// - Provides environment-specific settings

final class AppEnvironment: ObservableObject, BaseURLProvider, TokenProvider {

    // 🚀 **Shared Instance (Singleton)**
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

    /// 🔒 **Private Initializer - Ensures Singleton**
    private init() {}

    /// ✅ **Check if the App is Running in Production**
    var isProduction: Bool {
        scheme == .production
    }

    /// 🌍 **Fetch API Base URL from App Config**
    var baseURL: String {
        Bundle.main.getAppConfig(for: .baseURL) ?? ""
    }

    /// 🔐 **Fetch API Token from App Config**
    var token: String {
        Bundle.main.getAppConfig(for: .token) ?? ""
    }
}
