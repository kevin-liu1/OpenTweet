//
//  TweetCell.swift
//  OpenTweet
//
//  Created by Kevin Liu on 2024-07-17.
//  Copyright © 2024 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit

class TweetCell: UITableViewCell {
    var viewModel: TweetCellViewModel? {
        didSet {
            authorLabel.text = viewModel?.author
            dateLabel.text = viewModel?.date
            contentLabel.text = viewModel?.content
            
            if viewModel?.isAReplyTweet() == true {
                leadingConstraint.isActive = false
                replyLeadingConstraint.isActive = true
            } else {
                leadingConstraint.isActive = true
                replyLeadingConstraint.isActive = false
            }
            contentView.layoutIfNeeded()
        }
    }
    override class func awakeFromNib() {
        
    }
    
    private lazy var cardView: UIView = {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private lazy var authorLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.layoutMargins = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var leadingConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: textStackView, attribute: .leading, relatedBy: .equal, toItem: cardView, attribute: .leading, multiplier: 1, constant: 0)
        return constraint
    }()
    
    private lazy var replyLeadingConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: textStackView, attribute: .leading, relatedBy: .equal, toItem: cardView, attribute: .leading, multiplier: 1, constant: 16)
        return constraint
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpViews(){
        textStackView.addArrangedSubview(authorLabel)
        textStackView.addArrangedSubview(dateLabel)
        textStackView.addArrangedSubview(contentLabel)
        textStackView.addArrangedSubview(UIView())
        contentView.addSubview(textStackView)
        contentView.addSubview(cardView)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            //textStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: leadingConstraint),
            leadingConstraint,
            textStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            textStackView.topAnchor.constraint(equalTo: cardView.topAnchor),
            textStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
