//
//  ListViewDataType.swift
//  MeowMatch
//
//  Created by Vinsi on 31/01/2025.
//
import Foundation

protocol ListViewDataType {
    var breedID: String { get }
    var breedName: String { get }
    var breedOrigin: String { get }
    var breedTemperament: String { get }
    var breedDescription: String { get }
    var breedImageURL: URL? { get }
    var breedLifeSpan: String { get }
}

extension CatBreed: ListViewDataType {
    var breedID: String {
        id ?? ""
    }

    var breedName: String {
        name ?? ""
    }

    var breedOrigin: String {
        origin ?? ""
    }

    var breedTemperament: String {
        temperament ?? ""
    }

    var breedDescription: String {
        description ?? ""
    }

    var breedImageURL: URL? {
        imageURL
    }

    var breedLifeSpan: String {
        lifeSpan ?? ""
    }
}
