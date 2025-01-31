//
//  MockBreadListServiceType.swift
//  MeowMatch
//
//  Created by Vinsi.
//

struct MockBreadListServiceType: BreedListServiceType {
    private let action: () -> [CatBreed]
    init(onExecute: @escaping () -> [CatBreed] = { [.mock(), .mock(id: "1")] }) {
        action = onExecute
    }

    func getAll(page: Int, limit: Int) async throws -> [CatBreed] {
        action()
    }
}
