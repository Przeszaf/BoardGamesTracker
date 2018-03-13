//
//  PremadeGamesCell.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 17/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

//Cell used to display all players
class PremadeGamesCell: UITableViewCell {
    
    var gameNameLabel =  UILabel()
    var gameTypeLabel = UILabel()
    var gameIconImageView = UIImageView()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(gameNameLabel)
        contentView.addSubview(gameTypeLabel)
        contentView.addSubview(gameIconImageView)
        
        gameNameLabel.font = UIFont.systemFont(ofSize: 17)
        gameTypeLabel.font = UIFont.systemFont(ofSize: 10)
        gameTypeLabel.textColor = Constants.Global.detailTextColor
        
        gameIconImageView.layer.cornerRadius = 20
        gameIconImageView.layer.masksToBounds = true
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        gameNameLabel.frame = CGRect(x: 65, y: 0, width: frame.width - 110, height: frame.height - 15)
        gameTypeLabel.frame = CGRect(x: 65, y: frame.height - 20, width: frame.width/2 - 60, height: 10)
        gameIconImageView.frame = CGRect(x: 15, y: 7.5, width: 40, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
