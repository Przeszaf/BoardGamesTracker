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
    
    var playerName =  UITextView()
    var playerDate = UILabel()
    var playerTimesPlayed = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(playerName)
        contentView.addSubview(playerDate)
        contentView.addSubview(playerTimesPlayed)
        
        
        playerDate.font = UIFont.systemFont(ofSize: 10)
        playerDate.textColor = Constants.Global.detailTextColor
        playerTimesPlayed.font = UIFont.systemFont(ofSize: 10)
        playerName.font = UIFont.systemFont(ofSize: 17)
        playerName.isEditable = false
        playerName.isScrollEnabled = false
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerName.frame = CGRect(x: 15, y: 0, width: frame.width - 50, height: frame.height - 15)
        playerDate.frame = CGRect(x: 20, y: frame.height - 20, width: frame.width/2, height: 10)
        playerTimesPlayed.frame = CGRect(x: frame.width - 95, y: frame.height - 20, width: 90, height: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
