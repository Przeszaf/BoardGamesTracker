//
//  PVPViewCell.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 04/04/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit


class PVPCell: UITableViewCell {
    
    var firstPlayerResultLabel = UILabel()
    var secondPlayerResultLabel = UILabel()
    var dateLabel = UILabel()
    var gameImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        secondPlayerResultLabel.textAlignment = .right
        dateLabel.font = UIFont.systemFont(ofSize: 11)
        gameImageView.layer.cornerRadius = 20
        gameImageView.layer.masksToBounds = true
        gameImageView.backgroundColor = UIColor.red
        contentView.addSubview(firstPlayerResultLabel)
        contentView.addSubview(secondPlayerResultLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(gameImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        firstPlayerResultLabel.translatesAutoresizingMaskIntoConstraints = false
        secondPlayerResultLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        
        firstPlayerResultLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        firstPlayerResultLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        firstPlayerResultLabel.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
        
        secondPlayerResultLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        secondPlayerResultLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        secondPlayerResultLabel.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
        
        dateLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        
        gameImageView.bottomAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true
        gameImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        gameImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        gameImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
