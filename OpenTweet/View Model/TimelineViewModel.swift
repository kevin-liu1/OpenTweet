//
//  TimelineViewModel.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-17.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import Combine

class TimelineViewModel {
    private var tweets: [Tweet] = []
    var state = PassthroughSubject<State, Never>()
    
    func fetchTweets() {
        if let url = Bundle.main.url(forResource: "timeline", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let timeline = try decoder.decode(Timeline.self, from: data)
                tweets = timeline.timeline
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    func getAllTweets() -> [Tweet] {
        tweets
    }
    
    func getBaseTweets() -> [Tweet] {
        tweets.filter({ $0.inReplyTo == nil })
    }
}

enum State {
    case loading
    case complete
}
