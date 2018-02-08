//
//  AllMatchesCellProgramatically.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 01/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

//Cell to display matches of given game
class SelectedGameMatchesCell: UITableViewCell {
    
    var gameNameLabel = UILabel()
    var playersLabel =  UILabel()
    var dateLabel = UILabel()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(gameNameLabel)
        self.contentView.addSubview(playersLabel)
        self.contentView.addSubview(dateLabel)
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        gameNameLabel.numberOfLines = 0
        playersLabel.numberOfLines = 0
        playersLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        gameNameLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        playersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gameNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5).isActive = true
        gameNameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        gameNameLabel.trailingAnchor.constraint(equalTo: playersLabel.leadingAnchor, constant: -5).isActive = true
        gameNameLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor).isActive = true
        
        dateLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: gameNameLabel.trailingAnchor).isActive = true
        
        playersLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: frame.width/2 - 30).isActive = true
        playersLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        playersLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        playersLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
