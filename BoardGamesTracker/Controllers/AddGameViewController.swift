//
//  AddGame.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddGameViewController: UIViewController, UITextFieldDelegate {
    
    var gameStore: GameStore!
    
    //MARK: - Text fields and switch
    @IBOutlet var nameField: UITextField!
    @IBOutlet var maxPlayersField: UITextField!
    @IBOutlet var maxTeamsField: UITextField!
    @IBOutlet var gameTypeField: UITextField!
    
    @IBOutlet var areThereTeamsSwitch: UISwitch!
    
    
    //MARK: - Overriden functions
    override func viewDidLoad() {
        nameField.delegate = self
        maxPlayersField.delegate = self
        maxTeamsField.delegate = self
    }
    
    //MARK: - Switches and buttons
    @IBAction func areThereTeamsSwitchChanged(sender: UISwitch) {
        if sender.isOn {
            maxTeamsField.isEnabled = true
        } else {
            maxTeamsField.isEnabled = false
        }
    }
    
    @IBAction func addGameButtonPressed(_ sender: UIBarButtonItem) {
        
        if maxPlayersField.text == "" {
            maxPlayersField.shake()
        } else if nameField.text == ""{
            nameField.shake()
        } else {
            let boardGame = Game(name: nameField.text!, maxNoOfPlayers: Int(maxPlayersField.text!)!, maxNoOfTeams: nil, gameType: nil)
            gameStore.addGame(boardGame)
        }
    }
    
    //MARK: - Text field delegate methods
    
    //Taking care of correct inputs to textFields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameField {
            return true
        }
        if textField == maxPlayersField {
            if (Int(string) != nil && range.upperBound < 2 || string == "" ) {
                return true
            }
        } else if textField == maxTeamsField {
            if (Int(string) != nil && range.upperBound < 1 || string == "" ) {
                return true
            }
        }
        return false
    }
    
}
