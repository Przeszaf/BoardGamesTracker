//
//  Constants.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 03/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import BonMot

struct Constants {
    
    static let myStyle = StringStyle(
        .font(UIFont.systemFont(ofSize: 17)),
        .color(Global.mainTextColor),
        .xmlRules([
            .style("b", StringStyle(StringStyle.Part.font(BONFont.boldSystemFont(ofSize: 17)))),
            ])
    )
    
    struct Global {
        
        static let backgroundColor: UIColor = UIColor(red: 214/255, green: 214/255, blue: 224/255, alpha: 1)
        
        static let mainTextColor: UIColor = UIColor.black
        
        static let detailTextColor: UIColor = UIColor(white: 0.9, alpha: 1)
        
        static let chartColors: [UIColor] = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.cyan, UIColor(red: 0.5, green: 0, blue: 1, alpha: 1), UIColor(red: 0.9, green: 0.2, blue: 0.6, alpha: 1), UIColor.orange, UIColor(red: 0.1, green: 0.8, blue: 0.8, alpha: 1), UIColor(red: 0.1, green: 1, blue: 0.7, alpha: 1)]
    }
    
    struct Header {
        
        static let strokeColor = UIColor.lightGray.cgColor
        
        static let lineWidth: CGFloat = 2
        
    }
    
    struct Cell {
        
        static let gradientStartColor: CGColor = UIColor.lightGray.cgColor
        
        static let gradientEndColor: CGColor = UIColor.blue.cgColor
        
        static let gradientStartPoint: CGPoint = CGPoint(x: -0.5, y: 0)
        
        static let gradientEndPoint: CGPoint = CGPoint(x: 1.5, y: 1.5)
        
        static let radius: CGFloat = 15
        
        static let offsetX: CGFloat = 5
        
        static let offsetY: CGFloat = 5
        
        static let lineWidth: CGFloat = 1
        
        static let gradientSelectStartColor: CGColor = UIColor(white: 5/6, alpha: 1).cgColor
        
        static let gradientSelectEndColor: CGColor = UIColor(red: 0, green: 0, blue: 0.9, alpha: 1).cgColor
        
        static let gradientHighlightStartColor: CGColor = UIColor(white: 5/6, alpha: 1).cgColor
        
        static let gradientHighlightEndColor: CGColor = UIColor(red: 0, green: 0, blue: 0.9, alpha: 1).cgColor
    }
    
    struct Functions {
        
        static func createAlert(title: String, message: String) -> UIAlertController {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.red]), forKey: "attributedTitle")
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
