//
//  AddClassesCell.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddClassesCell: UITableViewCell {
    
    var playerNameLabel = UILabel()
    var playerClassTextView = AddMatchTextView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(playerNameLabel)
        contentView.addSubview(playerClassTextView)
        playerClassTextView.isScrollEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        playerClassTextView.translatesAutoresizingMaskIntoConstraints = false
        
        playerNameLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        playerNameLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        playerNameLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
        playerNameLabel.trailingAnchor.constraint(equalTo: playerClassTextView.leadingAnchor, constant: 8)
        
        
        
        playerClassTextView.centerYAnchor.constraint(equalTo: playerNameLabel.centerYAnchor).isActive = true
        playerClassTextView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        playerClassTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
