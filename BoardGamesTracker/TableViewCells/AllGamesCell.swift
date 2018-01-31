//
//  AllGamesCell.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 31/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AllGamesCell: UITableViewCell {
    
    var gameName =  UILabel()
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
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gameName.frame = CGRect(x: 20, y: 5, width: frame.width, height: 30)
        gameDate.frame = CGRect(x: 20, y: gameName.frame.height + 5, width: frame.width/2, height: 10)
        gameTimesPlayed.frame = CGRect(x: frame.width * 3 / 4, y: gameName.frame.height + 5, width: frame.width/4, height: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
