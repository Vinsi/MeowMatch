//
//  BreedSearchEndpoint.swift
//  MeowMatch
//
//  Created by Vinsi.
//

struct BreedSearchEndpoint: EndPointType {
    let request = RequestBuilder()
    let baseURL = BaseURLProvider.self
    init(baseURL: String, searchText: String) {
        request
            .add(baseURL: baseURL)
            .set(path: "v1/breeds/search")
            .addQuery(query: .init(key: "q", value: searchText))
            .addQuery(query: .init(key: "attach_image", value: "1"))
    }

    typealias Response = [CatBreed]
}
