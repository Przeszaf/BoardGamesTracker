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
    var gameType: GameType?
    
    var picker: UIPickerView!
    let myPickerDataPlayers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    var myPickerDataTypes = [GameType.SoloWithPoints, GameType.SoloWithPlaces, GameType.TeamWithPlaces, GameType.Cooperation]
    
    //MARK: - Text fields and switch outlets
    @IBOutlet var nameField: UITextField!
    @IBOutlet var maxPlayersField: UITextField!
    @IBOutlet var gameTypeField: UITextField!
    
    //MARK: - Overriden UIViewController functions
    override func viewDidLoad() {
        view.backgroundColor = Constants.Global.backgroundColor
        nameField.delegate = self
        maxPlayersField.delegate = self
        gameTypeField.delegate = self
        
        picker = UIPickerView()
        picker.delegate = self
        maxPlayersField.inputView = picker
        gameTypeField.inputView = picker
        
        //Creating picker toolbar
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelPicker))
        
        let toolbar = Constants.Functions.createToolbarWith(leftButton: cancelButton, rightButton: doneButton)
        
        maxPlayersField.inputAccessoryView = toolbar
        gameTypeField.inputAccessoryView = toolbar
        
        nameField.autocapitalizationType = .words
    }
    
    //MARK: - Switches and buttons functions
    
    @IBAction func addGameButtonPressed(_ sender: UIBarButtonItem) {
        
        var maxPlayers = 0
        if maxPlayersField.text! == "99+" {
            maxPlayers = 99
        } else if let playersNum = Int(maxPlayersField.text!){
            maxPlayers = playersNum
        } else {
            createFailureAlert(with: "Max players cannot be empty!")
            return
        }
        
        if nameField.text == "" {
            createFailureAlert(with: "Name cannot be empty")
            return
        }
        
        guard let type = gameType else {
            createFailureAlert(with: "Game type cannot be empty")
            return
        }
        
        let game = Game(name: nameField.text!, type: type, maxNoOfPlayers: maxPlayers)
        gameStore.addGame(game)
        createSuccessAlert(with: "Created \(game.name)!")
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == nameField {
            return true
        }
        
        guard let picker = textField.inputView as? UIPickerView else { return false }
        if textField == maxPlayersField {
            picker.tag = 0
            if maxPlayersField.text == "" {
                maxPlayersField.text = "1"
            }
            if let num = Int(maxPlayersField.text!) {
                picker.selectRow(num - 1, inComponent: 0, animated: false)
            } else {
                picker.selectRow(myPickerDataPlayers.count, inComponent: 0, animated: false)
            }
        } else if textField == gameTypeField {
            picker.tag = 1
            if gameTypeField.text == "" {
                gameTypeField.text = "Solo game with points"
                gameType = .SoloWithPoints
            }
            if let num = myPickerDataTypes.index(of: gameType!) {
                picker.selectRow(num, inComponent: 0, animated: false)
            }
        }
        picker.reloadAllComponents()
        return true
    }
    
    //MARK: - UIPickerView
    
    //UIPicker DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return myPickerDataPlayers.count + 1
        } else if pickerView.tag == 1 {
            return myPickerDataTypes.count
        }
        return 0
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            if row == myPickerDataPlayers.count {
                return "99+"
            } else {
                return String(myPickerDataPlayers[row])
            }
        }  else if pickerView.tag == 1 {
            switch myPickerDataTypes[row] {
            case .Cooperation:
                return "Cooperation game"
            case .SoloWithPlaces:
                return "Solo game with places"
            case .SoloWithPoints:
                return "Solo game with points"
            case .TeamWithPlaces:
                return "Team game"
            }
        }
        return nil
    }
    
    //UIPickerView delegate
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if pickerView.tag == 0 {
            if row == myPickerDataPlayers.count {
                maxPlayersField.text = "99+"
            } else {
                maxPlayersField.text = String(myPickerDataPlayers[row])
            }
        } else if pickerView.tag == 1 {
            gameType = myPickerDataTypes[row]
            switch myPickerDataTypes[row] {
            case .Cooperation:
                gameTypeField.text = "Cooperation game"
            case .SoloWithPlaces:
                gameTypeField.text = "Solo game with places"
            case .SoloWithPoints:
                gameTypeField.text = "Solo game with points"
            case .TeamWithPlaces:
                gameTypeField.text = "Team game"
            }
        }
    }
    
    
    //MARK: - Toolbar
    
    //PickerView Toolbar button functions
    @objc func donePicker() {
        if picker.tag == 0 {
            if picker.selectedRow(inComponent: 0) == myPickerDataPlayers.count {
                maxPlayersField.text = "99+"
            } else {
                maxPlayersField.text = String(myPickerDataPlayers[picker.selectedRow(inComponent: 0)])
            }
            maxPlayersField.resignFirstResponder()
        } else if picker.tag == 1 {
            gameTypeField.resignFirstResponder()
        }
    }
    
    @objc func cancelPicker() {
        if picker.tag == 0 {
            maxPlayersField.text = ""
            maxPlayersField.resignFirstResponder()
        } else if picker.tag == 1 {
            gameType = nil
            gameTypeField.text = ""
            gameTypeField.resignFirstResponder()
        }
    }
    
    //MARK: - Alerts
    
    //Success alert with given string that disappears after 1 second and pops to previous controller
    func createSuccessAlert(with string: String) {
        let alert = Constants.Functions.createAlert(title: "Success!", message: string)
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
        let alert = Constants.Functions.createAlert(title: "Failure!", message: string)
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
