//
//  Bundle+AppKeyHelper.swift
//  MeowMatch
//
//  Created by Vinsi.
//
import Foundation

extension Bundle {
    private static let configurationKey = "AppConfiguration"

    private var appConfiguration: [String: Any]? {
        guard let configuration = object(forInfoDictionaryKey: Bundle.configurationKey) as? [String: Any] else {
            assertionFailure("AppConfiguration is missing or invalid in Info.plist")
            return nil
        }
        return configuration
    }

    func getAppConfig(for key: AppInfoConfigurationKeys) -> String? {
        guard let value = appConfiguration?[key.rawValue] as? String else {
            assertionFailure("Key \(key) is missing or not a String in AppConfiguration")
            return nil
        }
        return value
    }
}

enum AppInfoConfigurationKeys: String {
    case baseURL = "BASE_URL"
    case token = "TOKEN"
    case scheme = "SCHEME_NAME"
}
