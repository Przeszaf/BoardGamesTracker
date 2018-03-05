//
//  AllGamesCell.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 31/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

//Cell used to display all games
class AllGamesCell: UITableViewCell {
    
    var gameName =  UITextView()
    var gameDate = UILabel()
    var gameTimesPlayed = UILabel()
    var gameIconImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(gameName)
        contentView.addSubview(gameDate)
        contentView.addSubview(gameTimesPlayed)
        contentView.addSubview(gameIconImageView)
        gameDate.font = UIFont.systemFont(ofSize: 10)
        gameDate.textColor = UIColor.darkGray
        gameTimesPlayed.font = UIFont.systemFont(ofSize: 10)
        gameName.font = UIFont.systemFont(ofSize: 17)
        gameName.isEditable = false
        gameName.isScrollEnabled = false
        gameName.backgroundColor = UIColor.clear
        
        gameIconImageView.layer.cornerRadius = 20
        gameIconImageView.layer.masksToBounds = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gameName.frame = CGRect(x: 60, y: 0, width: frame.width - 110, height: frame.height - 15)
        gameDate.frame = CGRect(x: 65, y: frame.height - 15, width: frame.width/2 - 60, height: 10)
        gameTimesPlayed.frame = CGRect(x: frame.width - 90, y: frame.height - 15, width: 90, height: 10)
        gameIconImageView.frame = CGRect(x: 15, y: 5, width: 40, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
