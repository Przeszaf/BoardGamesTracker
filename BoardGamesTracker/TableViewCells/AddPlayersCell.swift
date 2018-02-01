//
//  AddPlayersCell.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 01/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddPlayersCell: UITableViewCell {
    
    var playerName =  UITextField()
    var addButton = UIButton(type: UIButtonType.contactAdd)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(playerName)
        self.contentView.addSubview(addButton)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playerName.frame = CGRect(x: 20, y: 5, width: frame.width * 2 / 3, height: 30)
        addButton.frame = CGRect(x: playerName.frame.width + 5, y: 5, width: frame.width * 1 / 3 - 5, height: 30)
        playerName.keyboardType = UIKeyboardType.alphabet
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
