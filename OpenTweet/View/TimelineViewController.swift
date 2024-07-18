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
    var viewModel: TimeLineProtocol
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
        title = viewModel.title
        setUpBinding()
        setUpTableView()
        fetchTimeline()
	}
    
    init(viewModel: TimeLineProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBinding() {
        viewModel.state.sink {[weak self] state in
            switch state {
            case .loading:
                break
            case .complete:
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    if let mainTweet = self?.viewModel.mainTweet {
                        self?.scrollToTweet(tweet: mainTweet)
                    }
                }
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
    
    private func scrollToTweet(tweet: Tweet) {
        guard let tweetIndex = viewModel.getIndexOfTweet(tweet: tweet) else { return }
        let indexPath: IndexPath = .init(row: tweetIndex, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
}

extension TimelineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getAllTweets().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as? TweetCell {
            let tweet = viewModel.getAllTweets()[indexPath.row]
            let vm: TweetCellViewModel = .init(tweet: tweet)
            let tweetCellViewModel: TweetCellViewModel = vm
            cell.viewModel = tweetCellViewModel
            if tweet.id == viewModel.mainTweet?.id {
                cell.isFloatingEnabled = true
            } else {
                cell.isFloatingEnabled = false
            }
            return cell
        }
        assert(false, "unexpected element kind")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let tweet: Tweet = viewModel.getAllTweets()[indexPath.row]
        guard tweet.id != viewModel.mainTweet?.id else { return }
        
        let tweetThread: [Tweet] = viewModel.buildTweetThread(tweet: tweet)
        let vm: TimelineReplyViewModel = TimelineReplyViewModel()
        vm.mainTweet = tweet
        vm.tweets = tweetThread
        let vc = TimelineViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
