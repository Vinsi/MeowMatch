//
//  CatBreed+Mock.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation

extension CatBreed {
    static func mock(
        weight: Weight = Weight.mock(),
        id: String = "abys",
        name: String = "Abyssinian",
        temperament: String = "Active, Energetic, Independent",
        origin: String = "Egypt",
        lifeSpan: String = "14 - 15",
        referenceImageID: String = "0XYvRd7oD"
    ) -> CatBreed {
        CatBreed(
            weight: weight,
            id: id,
            name: name,
            cfaURL: nil,
            vetstreetURL: nil,
            vcahospitalsURL: nil,
            temperament: temperament,
            origin: origin,
            countryCodes: "EG",
            countryCode: "EG",
            description: "The Abyssinian is a joy to have.",
            lifeSpan: lifeSpan,
            indoor: 0,
            altNames: nil,
            adaptability: 5,
            affectionLevel: 5,
            childFriendly: 3,
            dogFriendly: 4,
            energyLevel: 5,
            grooming: 1,
            healthIssues: 2,
            intelligence: 5,
            sheddingLevel: 2,
            socialNeeds: 5,
            strangerFriendly: 5,
            vocalisation: 1,
            experimental: 0,
            hairless: 0,
            natural: 1,
            rare: 0,
            rex: 0,
            suppressedTail: 0,
            shortLegs: 0,
            wikipediaURL: nil,
            hypoallergenic: 0,
            referenceImageID: referenceImageID
        )
    }
}

extension Weight {
    static func mock(
        imperial: String = "7 - 10",
        metric: String = "3 - 5"
    ) -> Weight {
        Weight(imperial: imperial, metric: metric)
    }
}
