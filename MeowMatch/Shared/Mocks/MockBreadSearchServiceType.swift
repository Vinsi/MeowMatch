//
//  MockBreadSearchServiceType 2.swift
//  MeowMatch
//
//  Created by Vinsi.
//

struct MockBreadSearchServiceType: BreadSearchServiceType {
    private let action: () -> [CatBreed]
    init(onExecute: @escaping () -> [CatBreed] = { [.mock()] }) {
        action = onExecute
    }

    func search(query: String) async throws -> [CatBreed] {
        action()
    }
}
