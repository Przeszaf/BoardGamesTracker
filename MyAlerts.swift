//
//  MyAlerts.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 13/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class MyAlerts {
    
    //Creates custom alert
    
    static func createAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.setValue(NSAttributedString(string: alert.title!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.magenta]), forKey: "attributedTitle")
        alert.setValue(NSAttributedString(string: alert.message!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.blue]), forKey: "attributedMessage")
        return alert
    }
    
}
