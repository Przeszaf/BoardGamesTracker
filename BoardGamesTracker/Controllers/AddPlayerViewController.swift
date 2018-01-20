//
//  AddPlayerViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 19/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddPlayerViewController: UIViewController {
    
    @IBOutlet var field: UITextField!
    
    @IBAction func btn(_ sender: Any) {
        field.shake()
    }
}
