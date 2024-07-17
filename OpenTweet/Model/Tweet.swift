//
//  Tweet.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-17.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

struct Tweet: Decodable {
    var id: String
    var author: String
    var content: String
    var date: String
    var avatar: String?
    var inReplyTo: String?
}
