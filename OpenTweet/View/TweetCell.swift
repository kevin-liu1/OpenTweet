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
            contentLabel.attributedText = viewModel?.content
            contentView.layoutIfNeeded()
            
            Task {
                if let imageData = try await viewModel?.downloadImage() {
                    DispatchQueue.main.async {
                        self.avatarImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    var isFloatingEnabled: Bool = false {
        didSet {
            updateFloatingAppearance()
        }
    }
    
    override class func awakeFromNib() {}
    
    private lazy var cardView: UIView = {
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        return cardView
    }()
    
    private lazy var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 12
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .gray
        return imageView
    }()
    
    private lazy var authorLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var leadingConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: cardView, attribute: .leading, multiplier: 1, constant: 0)
        return constraint
    }()
    
    private lazy var replyLeadingConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: cardView, attribute: .leading, multiplier: 1, constant: 16)
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
        stackView.addArrangedSubview(avatarImage)
        stackView.addArrangedSubview(textStackView)
        contentView.addSubview(stackView)
        contentView.addSubview(cardView)
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            leadingConstraint,
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            avatarImage.heightAnchor.constraint(equalToConstant: 40),
            avatarImage.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func updateFloatingAppearance() {
        if isFloatingEnabled {
            // Configure cell appearance with floating effect
            layer.cornerRadius = 12
            layer.masksToBounds = false
            contentView.clipsToBounds = true
            backgroundColor = .white
            
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowOpacity = 0.4
            layer.shadowRadius = 2
        } else {
            // Remove floating effect
            layer.cornerRadius = 0
            layer.masksToBounds = true
            backgroundColor = .clear
            
            layer.shadowColor = nil
            layer.shadowOffset = CGSize.zero
            layer.shadowOpacity = 0
            layer.shadowRadius = 0
        }
    }
}
