//
//  DetailSection.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation

enum DetailSection: Identifiable {

    case images([URL])
    case links(sectionTitle: String, links: [(title: String, url: URL)])
    case description(sectionTitle: String, description: String)
    case attributes(sectionTitle: String, [(title: String, value: String)])

    var id: String {
        switch self {
        case .images:
            return "image"
        case .links:
            return "link"
        case .description:
            return "description"
        case .attributes:
            return "attribute"
        }
    }
}
