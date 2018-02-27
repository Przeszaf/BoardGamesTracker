//
//  AddInfoCell.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddInfoCell: UITableViewCell {
    
    var leftLabel = UILabel()
    var rightTextView = AddMatchTextView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightTextView)
        rightTextView.isScrollEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightTextView.translatesAutoresizingMaskIntoConstraints = false
        
        leftLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        leftLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        leftLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
        leftLabel.trailingAnchor.constraint(equalTo: rightTextView.leadingAnchor, constant: 8)
        
        
        
        rightTextView.centerYAnchor.constraint(equalTo: leftLabel.centerYAnchor).isActive = true
        rightTextView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        rightTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
