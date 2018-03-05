//
//  Constants.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 03/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

struct Constants {
    
    struct Global {
        
        static let backgroundColor: UIColor = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1)
    }
    
    struct Cell {
        
        static let gradientStartColor: CGColor = UIColor.lightGray.cgColor
        
        static let gradientEndColor: CGColor = UIColor.blue.cgColor
        
        static let gradientStartPoint: CGPoint = CGPoint(x: 0, y: 0)
        
        static let gradientEndPoint: CGPoint = CGPoint(x: 2, y: 2)
        
        static let radius: CGFloat = 15
        
        static let offsetX: CGFloat = 5
        
        static let offsetY: CGFloat = 5
        
        static let lineWidth: CGFloat = 1
        
        static let gradientSelectStartColor: CGColor = UIColor(white: 3/4, alpha: 1).cgColor
        
        static let gradientSelectEndColor: CGColor = UIColor.blue.cgColor
        
        static let gradientHighlightStartColor: CGColor = UIColor(white: 3/4, alpha: 1).cgColor
        
        static let gradientHighlightEndColor: CGColor = UIColor.blue.cgColor
    }
    
    struct Functions {
        
        static func createAlert(title: String, message: String) -> UIAlertController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.magenta]), forKey: "attributedTitle")
            alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.blue]), forKey: "attributedMessage")
            return alert
        }
        
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
}
