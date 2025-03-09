//
//  CatDetailViewModel.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import Foundation

/// 🐱 **ViewModel for Cat Details Screen**
/// - Handles fetching images, preparing attributes, and managing UI state.
/// - Uses `DataState` to track loading, success, and failure states.
final class CatDetailViewModel: ObservableObject {

    /// 🔄 **Published State**: Holds the current state of detail sections.
    @Published var sections: DataState<[DetailSection], any Error> = .notStarted

    /// 🐾 **Breed Information**
    let breed: CatBreed

    /// 📸 **Service to Fetch Breed Images**
    let service: CatImageServiceType

    init(service: CatImageServiceType, breed: CatBreed) {
        self.service = service
        self.breed = breed
    }

    func fetchImages() {
        sections = .fetching
        Task { [weak self] in
            guard let self, let id = self.breed.id else { return }
            do {
                let images = try await service.getImages(id: id)
                await MainActor.run {
                    self.createSections(imageURLs: images.compactMap(\.url?.asURL))
                }
            } catch {
                await MainActor.run {
                    self.sections = .failure(error)
                }
            }
        }
    }

    // MARK: - 🔗 Create Links

    /// Creates a list of external links related to the breed.
    /// - Returns: An array of tuples containing the link title and URL.
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

    // MARK: - 📊 Create Attributes

    /// Creates a list of breed-specific attributes for display.
    /// - Returns: An array of tuples containing attribute names and values.
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

    // MARK: - 📦 Create Sections

    /// Creates sections for the cat detail screen.
    /// - Parameter imageURLs: An array of image URLs.
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
