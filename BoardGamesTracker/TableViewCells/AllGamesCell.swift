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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(gameName)
        self.contentView.addSubview(gameDate)
        self.contentView.addSubview(gameTimesPlayed)
        gameDate.font = UIFont.systemFont(ofSize: 10)
        gameDate.textColor = UIColor.darkGray
        gameTimesPlayed.font = UIFont.systemFont(ofSize: 10)
        gameName.font = UIFont.systemFont(ofSize: 17)
        gameName.isEditable = false
        gameName.isScrollEnabled = false
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gameName.frame = CGRect(x: 15, y: 0, width: frame.width - 50, height: frame.height - 15)
        gameDate.frame = CGRect(x: 20, y: frame.height - 15, width: frame.width/2, height: 10)
        gameTimesPlayed.frame = CGRect(x: frame.width * 2 / 3, y: frame.height - 15, width: frame.width/3, height: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
