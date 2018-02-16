//
//  PlayerDetailsSectionView.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 15/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class PlayerDetailsSectionView: UIView {
    
    var titleLabel = UILabel()
    var expandButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = UIView(frame: frame)
        addSubview(view)
        view.addSubview(titleLabel)
        view.addSubview(expandButton)
        
        expandButton.backgroundColor = UIColor.red
        
    }
    
    override func layoutSubviews() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        expandButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        
        titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: expandButton.leadingAnchor).isActive = true
        
        expandButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        expandButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        expandButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        expandButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        expandButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
