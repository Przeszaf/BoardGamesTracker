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
    
    @IBOutlet var areThereTeamsSwitch: UISwitch!
    @IBOutlet var areTherePointsSwitch: UISwitch!
    @IBOutlet var areTherePlacesSwitch: UISwitch!
    
    
    //MARK: - Overriden UIViewController functions
    override func viewDidLoad() {
        nameField.delegate = self
        maxPlayersField.delegate = self
        
        picker = UIPickerView()
        picker.delegate = self
        maxPlayersField.inputView = picker
        
        areTherePlacesSwitch.isEnabled = false
        areTherePlacesSwitch.isOn = true
        
        //Creating picker toolbar
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        
        let toolbar = MyToolbar.createToolbarWith(leftButton: cancelButton, rightButton: doneButton)
        
        maxPlayersField.inputAccessoryView = toolbar
    }
    
    //MARK: - Switches and buttons functions
    
    @IBAction func addGameButtonPressed(_ sender: UIBarButtonItem) {
        
        var maxPlayers = 0
        var gameType: GameType?
        
        
        if maxPlayersField.text! == "99+" {
            maxPlayers = 99
        } else {
            if let players = Int(maxPlayersField.text!) {
                maxPlayers = players
            }
        }
        
        if maxPlayersField.text == "" {
            createFailureAlert(with: "Max players cannot be empty!")
            return
        } else if nameField.text == ""{
            createFailureAlert(with: "Name cannot be empty")
            return
        } else if !areThereTeamsSwitch.isOn && !areTherePointsSwitch.isOn {
            createFailureAlert(with: "Must turn switch on.")
            return
        }
        
        if areThereTeamsSwitch.isOn {
            gameType = .TeamWithPlaces
        } else if areTherePointsSwitch.isOn {
            gameType = .SoloWithPoints
        }
        
        if let type = gameType, let name = nameField.text  {
            let game = Game(name: name, type: type, maxNoOfPlayers: maxPlayers)
            gameStore.addGame(game)
            createSuccessAlert(with: "Created \(game.name)!")
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
            gameTypeField.text = "Solo game with points."
        } else {
            areTherePointsSwitch.isEnabled = true
            areThereTeamsSwitch.isEnabled = true
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
        
        return false
    }
    
    //MARK: - UIPickerView
    
    //UIPicker DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerDataPlayers.count + 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if row == myPickerDataPlayers.count {
            return "99+"
        } else {
            return String(myPickerDataPlayers[row])
        }
    }
    
    //UIPickerView delegate
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if row == myPickerDataPlayers.count {
            maxPlayersField.text = "99+"
        } else {
            maxPlayersField.text = String(myPickerDataPlayers[row])
        }
    }
    
    
    //MARK: - Toolbar
    
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
    
    //MARK: - Alerts
    
    //Success alert with given string that disappears after 1 second and pops to previous controller
    func createSuccessAlert(with string: String) {
        let alert = MyAlerts.createAlert(title: "Success!", message: string)
        self.present(alert, animated: true, completion: nil)
        let time = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: time) {
            alert.dismiss(animated: true, completion: {
                self.navigationController?.popToRootViewController(animated: true)
            })
        }
    }
    
    //Failure alert with string that disappears after 1 second
    func createFailureAlert(with string: String) {
        let alert = MyAlerts.createAlert(title: "Failure!", message: string)
        alert.addAction(UIAlertAction(title: "Ok!", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Other
    
    //If tapped outside of keyboard then end editing
    override func touchesBegan(_ touches: Set<UITouch>,
                               with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
}
