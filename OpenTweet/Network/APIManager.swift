//
//  APIManager.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-17.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

protocol APIManagerProtocol {
    func perform(_ request: RequestProtocol) async throws -> Data
}

class APIManager: APIManagerProtocol {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func perform(_ request: RequestProtocol) async throws -> Data {
        let urlRequest = try request.createURLRequest()
        if let data = CacheManager.shared.fetchDataFromCache(request: urlRequest) {
            return data
        }
        let (data, response) = try await urlSession.data(for: request.createURLRequest())
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidServerResponse
        }
        //caching images only
        if let _ = request as? ImageRequest {
            CacheManager.shared.storeDataToCache(request: urlRequest, data: data)
        }
        return data
    }
}
