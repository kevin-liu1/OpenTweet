//
//  TimelineReplyViewModel.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-17.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import Combine

class TimelineReplyViewModel: TimeLineProtocol {
    var mainTweet: Tweet?
    var title: String = "Post"
    var state = PassthroughSubject<State, Never>()
    var tweets: [Tweet] = []
    
    func fetchTweets() {}
}
