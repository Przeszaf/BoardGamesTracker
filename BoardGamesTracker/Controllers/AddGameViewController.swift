//
//  AddGame.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddGameViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var gameStore: GameStore!
    let myPickerDataPlayers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    var picker: UIPickerView!
    
    //MARK: - Text fields and switch outlets
    @IBOutlet var nameField: UITextField!
    @IBOutlet var maxPlayersField: UITextField!
    @IBOutlet var gameTypeField: UITextField!
    @IBOutlet var maxPointsField: UITextField!
    
    @IBOutlet var areThereTeamsSwitch: UISwitch!
    @IBOutlet var areTherePointsSwitch: UISwitch!
    @IBOutlet var areTherePlacesSwitch: UISwitch!
    
    //MARK: - Variables needed to create game
    
    //MARK: - Overriden UIViewController functions
    override func viewDidLoad() {
        nameField.delegate = self
        maxPlayersField.delegate = self
        maxPointsField.delegate = self
        
        picker = UIPickerView()
        picker.delegate = self
        maxPlayersField.inputView = picker
        
        areTherePlacesSwitch.isEnabled = false
        areTherePlacesSwitch.isOn = true
        
        //Creating picker toolbar
        let toolBar = createToolbar()
        
        maxPlayersField.inputAccessoryView = toolBar
    }
    
    //MARK: - Switches and buttons functions
    
    @IBAction func addGameButtonPressed(_ sender: UIBarButtonItem) {
        
        var maxPlayers = 0
        var maxPoints: Int?
        var gameType: GameType?
        
        if let points = Int(maxPointsField.text!) {
            maxPoints = points
        }
        
        if maxPlayersField.text! == "99+" {
            maxPlayers = 99
        } else {
            if let players = Int(maxPlayersField.text!) {
                maxPlayers = players
            }
        }
        
        if maxPlayersField.text == "" {
            maxPlayersField.shake()
            return
        } else if nameField.text == ""{
            nameField.shake()
            return
        } else if !areThereTeamsSwitch.isOn && !areTherePointsSwitch.isOn {
            maxPlayersField.shake()
            return
        }
        
        if areThereTeamsSwitch.isOn {
            gameType = .TeamWithPlaces
            maxPoints = nil
        } else if areTherePointsSwitch.isOn {
            gameType = .SoloWithPoints
        }
        
        if let type = gameType, let name = nameField.text  {
            let game = Game(name: name, type: type, maxNoOfPlayers: maxPlayers, maxPoints: maxPoints)
            gameStore.addGame(game)
        }
    }
    
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if areThereTeamsSwitch.isOn && !areTherePointsSwitch.isOn {
            areTherePointsSwitch.isOn = false
            areTherePointsSwitch.isEnabled = false
            areTherePlacesSwitch.isOn = true
            areTherePlacesSwitch.isEnabled = false
            gameTypeField.text = "Team game with places."
            
        } else if areTherePointsSwitch.isOn && !areThereTeamsSwitch.isOn {
            areThereTeamsSwitch.isOn = false
            areThereTeamsSwitch.isEnabled = false
            areTherePlacesSwitch.isOn = true
            areTherePlacesSwitch.isEnabled = false
            maxPointsField.isEnabled = true
            gameTypeField.text = "Solo game with points."
        } else {
            areTherePointsSwitch.isEnabled = true
            areThereTeamsSwitch.isEnabled = true
            maxPointsField.isEnabled = false
            maxPointsField.text = ""
            gameTypeField.text = ""
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
                let numString = textField.text! + string
                let num = Int(numString)!
                if num >= 1 && num <= 20 {
                    return true
                }
            }
        }
        
        if textField == maxPointsField {
            if (Int(string) != nil && range.upperBound < 3 || string == "" ) {
                let numString = textField.text! + string
                let num = Int(numString)!
                if num >= 1 && num <= 999 {
                    return true
                }
            }
        }
        return false
    }
    
    //MARK: - UIPickerView DataSource and Delegate methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerDataPlayers.count + 1
    }
    
    //
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if row == myPickerDataPlayers.count {
            return "99+"
        } else {
            return String(myPickerDataPlayers[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if row == myPickerDataPlayers.count {
            maxPlayersField.text = "99+"
        } else {
            maxPlayersField.text = String(myPickerDataPlayers[row])
        }
    }
    
    //If tapped outside of keyboard then end editing
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: - Creating toolbar
    
    func createToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    //PickerView Toolbar button functions
    @objc func donePicker() {
        if picker.selectedRow(inComponent: 0) == myPickerDataPlayers.count {
            maxPlayersField.text = "99+"
        } else {
            maxPlayersField.text = String(myPickerDataPlayers[picker.selectedRow(inComponent: 0)])
        }
        maxPlayersField.resignFirstResponder()
    }
    
    @objc func cancelPicker() {
        maxPlayersField.text = ""
        maxPlayersField.resignFirstResponder()
    }
    
}
