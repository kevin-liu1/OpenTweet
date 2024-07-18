//
//  ImageRequest.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-17.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

enum ImageRequest: RequestProtocol {
    case fetchImage(url: String)
    
    var urlString: String {
        switch self {
        case .fetchImage(let url):
            return url
        }
    }
    
    var host: String {
        ""
    }
    var path: String {
        ""
    }
    
    var requestType: RequestType {
        .GET
    }
}
