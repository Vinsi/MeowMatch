//
//  CatImagesEndpoint.swift
//  MeowMatch
//
//  Created by Vinsi.
//

struct CatImagesEndpoint: EndPointType {
    let request = RequestBuilder()
    init(baseURL: String, id: String, limit: Int = 10) {
        request
            .add(baseURL: baseURL)
            .set(path: "v1/images/search")
            .addQuery(query: .init(key: "limit", value: "\(limit)"))
            .addQuery(query: .init(key: "breed_ids", value: "\(id)"))
    }

    typealias Response = [CatImage]
}
