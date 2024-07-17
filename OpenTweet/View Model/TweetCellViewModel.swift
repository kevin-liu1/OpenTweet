//
//  TweetCellViewModel.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-17.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

class TweetCellViewModel {
    var author: String
    var content: String
    var date: String
    var avatar: String?
    var inReplyTo: String?
    
    init(tweet: Tweet) {
        self.author = tweet.author
        self.content = tweet.content
        self.date = tweet.date
        self.avatar = tweet.avatar
        self.inReplyTo = tweet.inReplyTo
    }
    
    func isAReplyTweet() -> Bool {
        inReplyTo != nil
    }
}
