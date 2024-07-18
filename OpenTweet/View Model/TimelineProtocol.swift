//
//  TimelineProtocol.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-18.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import Combine

protocol TimeLineProtocol {
    var title: String { get }
    var state: PassthroughSubject<State,Never> { get }
    var tweets: [Tweet] { get }
    var mainTweet: Tweet? { get }
    func fetchTweets()
    func getAllTweets() -> [Tweet]
    func getIndexOfTweet(tweet: Tweet) -> Int?
    func getParentThread(tweetThread: inout [Tweet])
    func getChildrenThread(tweetThread: inout [Tweet])
    func buildTweetThread(tweet: Tweet) -> [Tweet]
}

extension TimeLineProtocol {
    func getAllTweets() -> [Tweet] {
        tweets
    }
    
    func getIndexOfTweet(tweet: Tweet) -> Int? {
        tweets.firstIndex(where: { $0.id == tweet.id })
    }
    
    func getParentThread(tweetThread: inout [Tweet]) {
        guard let parent = tweets.first(where: {$0.id == tweetThread.first?.inReplyTo}) else { return }
        tweetThread.insert(parent, at: 0)
        getParentThread(tweetThread: &tweetThread)
    }
    
    //Depth first search for children thread
    func getChildrenThread(tweetThread: inout [Tweet]) {
        guard let current = tweetThread.last else { return }
        let children = tweets.filter({$0.inReplyTo == current.id})
        guard !children.isEmpty else { return }
        for child in children {
            tweetThread.append(child)
            getChildrenThread(tweetThread: &tweetThread)
        }
    }
    
    func buildTweetThread(tweet: Tweet) -> [Tweet] {
        var tweetThread: [Tweet] = [tweet]
        getParentThread(tweetThread: &tweetThread)
        getChildrenThread(tweetThread: &tweetThread)
        return tweetThread
    }
}
