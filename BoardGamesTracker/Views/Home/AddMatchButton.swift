//
//  AddMatchButton.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 28/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

@IBDesignable class AddMatchButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
        layer.cornerRadius = 15
        layer.borderWidth = 3
        layer.borderColor = UIColor.gray.cgColor
        layer.backgroundColor = UIColor.lightGray.cgColor
    }
    
    
}
