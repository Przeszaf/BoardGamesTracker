//
//  AllMatchesCellProgramatically.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 01/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

//Cell to display matches of given game
class SelectedGameMatchesCell: UITableViewCell {
    
    var playersLabel =  UILabel()
    var dateLabel = UILabel()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(playersLabel)
        contentView.addSubview(dateLabel)
        dateLabel.font = UIFont.systemFont(ofSize: 10)
        dateLabel.textColor = Constants.Global.detailTextColor
        playersLabel.numberOfLines = 0
        playersLabel.font = UIFont.systemFont(ofSize: 17)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        playersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        playersLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        playersLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        playersLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: playersLabel.bottomAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: playersLabel.leadingAnchor).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
