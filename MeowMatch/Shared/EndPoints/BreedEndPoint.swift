//
//  BreedEndPoint.swift
//  MeowMatch
//
//  Created by Vinsi.
//

struct BreedEndPoint: EndPointType {
    let request = RequestBuilder()
    init(baseURL: String, page: Int = 0, limit: Int = 10) {
        request
            .add(baseURL: baseURL)
            .set(path: "v1/breeds")
            .addQuery(query: .init(key: "limit", value: "\(limit)"))
            .addQuery(query: .init(key: "page", value: "\(page)"))
    }

    typealias Response = [CatBreed]
}
