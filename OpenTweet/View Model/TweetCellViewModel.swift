//
//  TweetCellViewModel.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-17.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation

class TweetCellViewModel {
    var requestManager: RequestManagerProtocol? = RequestManager()
    var author: String
    var content: String
    var date: String
    var avatar: String?
    var inReplyTo: String?
    var avatarURL: String?
    
    init(tweet: Tweet) {
        self.author = tweet.author
        self.content = tweet.content
        if let formattedDate: Date = DateFormat.formatDateFromString(tweet.date) {
            self.date = DateFormat.convertToPrettyString(from: formattedDate)
        } else {
            self.date = tweet.date
        }
        
        self.avatar = tweet.avatar
        self.inReplyTo = tweet.inReplyTo
    }
    
    func isAReplyTweet() -> Bool {
        inReplyTo != nil
    }
    
    //passing data because UI elements shouldn't be handled in View Model
    func downloadImage() async throws -> Data {
        guard let requestManager = requestManager, let imageURL = avatar else {
            throw NetworkError.invalidRequest
        }
        let data = try await downloadImageData(with: imageURL, network: requestManager)
        return data
    }
    
    private func downloadImageData(with url: String, network: RequestManagerProtocol) async throws -> Data {
        let data = try await network.performImageDownload(ImageRequest.fetchImage(url: url))
        return data
    }
}
