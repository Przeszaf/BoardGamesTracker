//
//  AllPlayersCell.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 01/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

//Cell used to display all players 
class AllPlayersCell: UITableViewCell {
    
    var playerName =  UILabel()
    var playerDate = UILabel()
    var playerTimesPlayed = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(playerName)
        self.contentView.addSubview(playerDate)
        self.contentView.addSubview(playerTimesPlayed)
        playerDate.font = UIFont.systemFont(ofSize: 10)
        playerDate.textColor = UIColor.darkGray
        playerTimesPlayed.font = UIFont.systemFont(ofSize: 10)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerName.frame = CGRect(x: 20, y: 5, width: frame.width, height: 30)
        playerDate.frame = CGRect(x: 20, y: playerName.frame.height + 5, width: frame.width/2, height: 10)
        playerTimesPlayed.frame = CGRect(x: frame.width * 3 / 4, y: playerName.frame.height + 5, width: frame.width/4, height: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
