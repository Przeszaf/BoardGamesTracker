//
//  PlayerDetailsCell.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 07/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

//Cell used to display player details
class PlayerDetailsCell: UITableViewCell {
    
    var playersLabel = UILabel()
    var dateLabel = UILabel()
    var placeLabel = UILabel()
    var classLabel = UILabel()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(playersLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(placeLabel)
        contentView.addSubview(classLabel)
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textColor = Constants.Global.detailTextColor
        playersLabel.font = UIFont.systemFont(ofSize: 17)
        placeLabel.font = UIFont.systemFont(ofSize: 17)
        playersLabel.numberOfLines = 0
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playersLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        placeLabel.translatesAutoresizingMaskIntoConstraints = false
        classLabel.translatesAutoresizingMaskIntoConstraints = false
        
        playersLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        playersLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        
        classLabel.topAnchor.constraint(equalTo: playersLabel.bottomAnchor).isActive = true
        classLabel.leadingAnchor.constraint(equalTo: playersLabel.leadingAnchor).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: classLabel.bottomAnchor, constant: 0).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: classLabel.leadingAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        
        placeLabel.centerYAnchor.constraint(equalTo: playersLabel.centerYAnchor).isActive = true
        placeLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        placeLabel.trailingAnchor.constraint(equalTo: playersLabel.leadingAnchor, constant: 4).isActive = true
        placeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
