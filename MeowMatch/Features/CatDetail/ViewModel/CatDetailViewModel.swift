//
//  CatDetailViewModel.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation

final class CatDetailViewModel: ObservableObject {
    @Published var sections: DataState<[DetailSection], any Error> = .notStarted

    let breed: CatBreed
    let service: CatImageServiceType

    init(service: CatImageServiceType, breed: CatBreed) {
        self.service = service
        self.breed = breed
    }

    func fetchImages() {
        sections = .fetching
        Task { [weak self] in
            guard let self, let id = self.breed.id else { return }
            let images = try await service.getImages(id: id)
            DispatchQueue.main.async { [self] in
                self.createSections(imageURLs: images.compactMap(\.url?.asURL))
            }
        }
    }

    private func createLinks() -> [(String, URL)] {
        return [
            (Localized.Links.wikipedia, breed.wikipediaURL),
            (Localized.Links.cfa, breed.cfaURL),
            (Localized.Links.vetStreet, breed.vetstreetURL),
            (Localized.Links.vcaHospital, breed.vcahospitalsURL),
        ]
        .compactMap {
            guard let url = $0.1?.asURL else { return nil }
            return ($0.0, url)
        }
    }

    private func createAttributes() -> [(String, String)] {
        [
            (Localized.Attributes.adaptability, breed.adaptability?.as5star),
            (Localized.Attributes.affectionLevel, breed.affectionLevel?.as5star),
            (Localized.Attributes.childFriendly, breed.childFriendly?.as5star),
            (Localized.Attributes.dogFriendly, breed.dogFriendly?.as5star),
            (Localized.Attributes.energyLevel, breed.energyLevel?.as5star),
            (Localized.Attributes.grooming, breed.grooming?.as5star),
            (Localized.Attributes.healthIssues, breed.healthIssues?.as5star),
            (Localized.Attributes.intelligence, breed.intelligence?.as5star),
            (Localized.Attributes.sheddingLevel, breed.sheddingLevel?.as5star),
            (Localized.Attributes.lifeSpan, breed.lifeSpan),
            (Localized.Attributes.temperament, breed.temperament),
        ]
        .compactMap { value -> (String, String)? in
            guard let text = value.1 else {
                return nil
            }
            return (value.0, text)
        }
    }

    private func createSections(imageURLs: [URL]) {
        var sections = [DetailSection]()
        sections.append(.images(imageURLs))
        sections.append(.description(sectionTitle: breed.name ?? "", description: breed.description ?? ""))
        sections.append(.attributes(sectionTitle: Localized.attributes, createAttributes()))
        sections.append(.links(sectionTitle: Localized.learnMore, links: createLinks()))
        self.sections = .success(sections)
    }
}

private extension Int {
    var as5star: String {
        String(repeating: "★", count: self) + String(repeating: "☆", count: 5 - self)
    }
}
