//
//  Localized.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation

enum Localized {
    // General Titles
    static let detailTitle = String(localized: "detail_title")
    static let breedTitle = String(localized: "breed_list_title")
    static let searchTitle = String(localized: "search_title")
    static let settingTitle = String(localized: "setting_title")
    static let searchBreedPlaceholder = String(localized: "search_breed_placeholder")
    static let searchBreedButton = String(localized: "search_breed_button")
    static let learnMore = String(localized: "learn_more")
    static let attributes = String(localized: "attributes")
    static let selectLanguage = String(localized: "select_language")
    static let language = String(localized: "language")

    enum ErrorAlert {
        static let title = String(localized: "error")
        static let retry = String(localized: "retry")
    }

    // Error Messages
    enum Error {
        static let malformedURL = String(localized: "malformed_url")
        static let unknown = String(localized: "unknown")
        static let disconnected = String(localized: "disconnected")
        static let noInternetConnection = String(localized: "no_internet_connection")
        static let connectionError = String(localized: "connection_error")
        static func failedToDecode(message: String) -> String {
            String(format: NSLocalizedString("failed_to_decode", comment: ""), message)
        }
    }

    // Breed Details
    enum Breed {
        static func lifeSpan(_ years: String) -> String {
            String(format: NSLocalizedString("life_span", comment: ""), years)
        }

        static func origin(_ country: String) -> String {
            String(format: NSLocalizedString("origin", comment: ""), country)
        }
    }

    // Attributes
    enum Attributes {
        static let adaptability = String(localized: "adaptability")
        static let affectionLevel = String(localized: "affection_level")
        static let childFriendly = String(localized: "child_friendly")
        static let dogFriendly = String(localized: "dog_friendly")
        static let energyLevel = String(localized: "energy_level")
        static let grooming = String(localized: "grooming")
        static let healthIssues = String(localized: "health_issues")
        static let intelligence = String(localized: "intelligence")
        static let sheddingLevel = String(localized: "shedding_level")
        static let lifeSpan = String(localized: "life_span_attribute")
        static let temperament = String(localized: "temperament")
    }

    // Links
    enum Links {
        static let wikipedia = String(localized: "wikipedia")
        static let cfa = String(localized: "cfa")
        static let vetStreet = String(localized: "vetstreet")
        static let vcaHospital = String(localized: "vca_hospital")
    }
}
