//
//  AddPointsCell.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 27/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddPointsCell: UITableViewCell {
    
    var playerNameLabel = UILabel()
    
    var playerPointsField = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(playerNameLabel)
        self.contentView.addSubview(playerPointsField)
        playerPointsField.borderStyle = .roundedRect
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playerPointsField.translatesAutoresizingMaskIntoConstraints = false
        
        playerNameLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        playerNameLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        playerNameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
        playerNameLabel.trailingAnchor.constraint(equalTo: playerPointsField.leadingAnchor, constant: 8)
        
        playerPointsField.centerYAnchor.constraint(equalTo: playerNameLabel.centerYAnchor).isActive = true
        playerPointsField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: 0).isActive = true
        playerPointsField.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
