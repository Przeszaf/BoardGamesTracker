//
//  AddPlayerViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 19/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddPlayerViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Text field outlets
    @IBOutlet var nameField: UITextField!
    
    //MARK: - Overriden UIViewController functions
    override func viewDidLoad() {
        nameField.delegate = self
    }
    
    //MARK: - TextField delegate methods
    
    //Taking care of correct inputs to textFields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if Int(string) == nil {
            return true
        }
        else {
            return false
        }
    }
    
    
}
