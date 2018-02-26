//
//  MyToolbar.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 13/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class MyToolbar {
    
    static func createToolbarWith(leftButton: UIBarButtonItem, rightButton: UIBarButtonItem) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolbar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([leftButton, spaceButton, rightButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        return toolbar
    }
}
