//
//  AddNumsCell.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 27/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

//Cell used to add points to players

class AddNumsCell: UITableViewCell {
    
    var playerNameLabel = UILabel()
    var playerNumField = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(playerNameLabel)
        contentView.addSubview(playerNumField)
        playerNumField.borderStyle = .roundedRect
        playerNumField.keyboardType = .numberPad
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playerNumField.translatesAutoresizingMaskIntoConstraints = false
        
        playerNameLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        playerNameLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        playerNameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
        playerNameLabel.trailingAnchor.constraint(equalTo: playerNumField.leadingAnchor, constant: 8)
        
        playerNumField.centerYAnchor.constraint(equalTo: playerNameLabel.centerYAnchor).isActive = true
        playerNumField.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -20).isActive = true
        playerNumField.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
