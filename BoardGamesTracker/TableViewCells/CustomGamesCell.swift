//
//  CustomGamesCell.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 17/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

//Cell used to display all players
class CustomGameCell: UITableViewCell {
    
    var gameNameLabel =  UILabel()
    var gameTypeLabel = UILabel()
    var gameIconImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(gameNameLabel)
        self.contentView.addSubview(gameTypeLabel)
        self.contentView.addSubview(gameIconImageView)
        
        gameNameLabel.font = UIFont.systemFont(ofSize: 17)
        gameTypeLabel.font = UIFont.systemFont(ofSize: 10)
        gameTypeLabel.textColor = UIColor.darkGray
        gameIconImageView.backgroundColor = UIColor.brown
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        gameNameLabel.frame = CGRect(x: 50, y: 10, width: frame.width - 60, height: 30)
        gameTypeLabel.frame = CGRect(x: 50, y: 40, width: frame.width - 60, height: 15)
        gameIconImageView.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
