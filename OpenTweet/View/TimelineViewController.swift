//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit
import Combine

class TimelineViewController: UIViewController {
    
    var viewModel: TimelineViewModel = TimelineViewModel()
    private var cancelBag: [AnyCancellable] = []
    
    private lazy var tableView: UITableView = {
        var tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TweetCell.self, forCellReuseIdentifier: "TweetCell")
        return tableView
    }()

	override func viewDidLoad() {
		super.viewDidLoad()
        title = "OpenTweet"
        setUpBinding()
        setUpTableView()
        fetchTimeline()
	}
    
    private func setUpBinding() {
        viewModel.state.sink {[weak self] state in
            switch state {
            case .loading:
                break
            case .complete:
                self?.tableView.reloadData()
            }
        }.store(in: &cancelBag)
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        view.addSubview(tableView)
    }

    private func fetchTimeline() {
        viewModel.fetchTweets()
    }
}

extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getAllTweets().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as? TweetCell {
            let tweet = viewModel.getAllTweets()[indexPath.row]
            let tweetCellViewModel: TweetCellViewModel = .init(tweet: tweet)
            cell.viewModel = tweetCellViewModel
            return cell
        }
        assert(false, "unexpected element kind")
    }
}
