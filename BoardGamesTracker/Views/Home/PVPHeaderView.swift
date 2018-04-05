//
//  PVPHeaderView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 05/04/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class PVPHeaderView: UIView {
    
    var firstPlayerNameLabel = UILabel()
    var secondPlayerNameLabel = UILabel()
    var centerLabel = UILabel()
    var firstPlayerScoreLabel = UILabel()
    var secondPlayerScoreLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(firstPlayerNameLabel)
        addSubview(secondPlayerNameLabel)
        addSubview(centerLabel)
        addSubview(firstPlayerScoreLabel)
        addSubview(secondPlayerScoreLabel)
        
        let font = UIFont.boldSystemFont(ofSize: 20)
        
        
        firstPlayerNameLabel.font = font
        secondPlayerNameLabel.font = font
        centerLabel.font = font
        firstPlayerScoreLabel.font = font
        secondPlayerScoreLabel.font = font
        
        firstPlayerNameLabel.textAlignment = .center
        secondPlayerNameLabel.textAlignment = .center
        
        centerLabel.text = "-"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        firstPlayerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        secondPlayerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        firstPlayerScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        secondPlayerScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        firstPlayerNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant:  -self.frame.width / 4).isActive = true
        firstPlayerNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -self.frame.height / 4).isActive = true
        firstPlayerNameLabel.widthAnchor.constraint(equalToConstant: self.frame.width / 2).isActive = true
        
        secondPlayerNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant:  self.frame.width / 4).isActive = true
        secondPlayerNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -self.frame.height / 4).isActive = true
        secondPlayerNameLabel.widthAnchor.constraint(equalToConstant: self.frame.width / 2).isActive = true
        
        centerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: self.frame.height / 4 ).isActive = true
        centerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        firstPlayerScoreLabel.centerXAnchor.constraint(equalTo: firstPlayerNameLabel.centerXAnchor).isActive = true
        firstPlayerScoreLabel.centerYAnchor.constraint(equalTo: centerLabel.centerYAnchor).isActive = true
        
        secondPlayerScoreLabel.centerXAnchor.constraint(equalTo: secondPlayerNameLabel.centerXAnchor).isActive = true
        secondPlayerScoreLabel.centerYAnchor.constraint(equalTo: centerLabel.centerYAnchor).isActive = true
    }
}
