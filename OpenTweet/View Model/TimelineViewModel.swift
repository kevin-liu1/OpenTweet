//
//  TimelineViewModel.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-17.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import Combine

class TimelineViewModel: TimeLineProtocol {
    var mainTweet: Tweet?
    
    var title: String = "OpenTweet"
    var tweets: [Tweet] = []
    var state = PassthroughSubject<State, Never>()
    
    func fetchTweets() {
        if let url = Bundle.main.url(forResource: "timeline", withExtension: "json") {
            do {
                state.send(.loading)
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let timeline = try decoder.decode(Timeline.self, from: data)
                tweets = timeline.timeline
                state.send(.complete)
            } catch {
                state.send(.complete)
                print("error: \(error)")
            }
        }
    }

}
