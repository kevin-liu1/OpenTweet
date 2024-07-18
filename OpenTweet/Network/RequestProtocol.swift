//
//  RequestProtocol.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-17.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

protocol RequestProtocol {
    var urlString: String { get }
    var host: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    var urlParams: [String: String?] { get }
    var requestType: RequestType { get }
}

//I usually write this as the network layer to handle all network calls
//Since only the only network request is images, we will only be handling that case here.
extension RequestProtocol {
    var urlString: String {
        ""
    }
    
    var host: String {
        ""
    }
    
    var params: [String: Any] {
        [:]
    }
    
    var urlParams: [String: String?] {
        [:]
    }
    
    var headers: [String: String] {
        [:]
    }
    
    func createURLRequest() throws -> URLRequest {
        //Handle Image Requests
        if let url = URL(string: urlString) {
            return URLRequest(url: url)
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        
        if !urlParams.isEmpty {
            components.queryItems = urlParams.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = components.url else { throw NetworkError.URLError }
        
        var urlRequest = URLRequest(url: url)
        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }
        
        return urlRequest
    }
}

enum RequestType {
    case GET
    case PUT
}

enum NetworkError: Error {
    case URLError
    case invalidServerResponse
    case invalidRequest
    
    public var errorDescription: String? {
        switch self {
        case .URLError:
            return "URL Error"
        case .invalidServerResponse:
            return "Server Error"
        case .invalidRequest:
            return "Invalid Request"
        }
    }
}
