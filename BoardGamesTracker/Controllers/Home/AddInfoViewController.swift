//
//  AddInfoViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AdditionalInfoViewController: UITableViewController, UINavigationControllerDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var picker: UIPickerView!
    
    var myPickerData: [GameClass]!
    var myPickerDataEvil: [GameClass]!
    var myPickerDataGood: [GameClass]!
    
    var dictionaryName: String!
    var dictionaryKeys: [String]!
    var dictionaryValues: [String]!
    
    var game: Game!
    var availablePlayers: [Player]!
    var playersClasses = [Player: GameClass]()
    var winners: [Player]!
    var loosers: [Player]!
    var toolbar: UIToolbar!
    var currentRow: Int?
    var segueKey: String?
    var dictionary = [String: Any]()
    
    //MARK: - UITableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        tableView.allowsSelection = false
        tableView.register(AddInfoCell.self, forCellReuseIdentifier: "AddInfoCell")
        
        picker = UIPickerView()
        picker.delegate = self
        
        let leftButton = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(toolbarHideButton))
        let rightButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(toolbarNextButton))
        toolbar = Constants.Functions.createToolbarWith(leftButton: leftButton, rightButton: rightButton)
        
        
        if !winners.isEmpty || !loosers.isEmpty {
            availablePlayers = winners! + loosers!
        }
        tableView.backgroundColor = Constants.Global.backgroundColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    //MARK: - UITableView
    
    //MARK
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddInfoCell", for: indexPath) as! AddInfoCell
        cell.rightTextView.delegate = self
        cell.rightTextView.tag = indexPath.row
        cell.rightTextView.inputAccessoryView = toolbar
        cell.rightTextView.inputView = picker
        
        if segueKey == "Classes", let player = availablePlayers?[indexPath.row] {
            cell.leftLabel.text = player.name
            cell.rightTextView.text = playersClasses[player]?.name!
        } else if segueKey == "Other" {
            let key = dictionaryKeys[indexPath.row]
            cell.leftLabel.text = key
            cell.rightTextView.text = dictionary[key] as? String
        }
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segueKey == "Classes" {
            return availablePlayers!.count
        } else if segueKey == "Other" {
            return dictionaryKeys.count
        }
        return 0
    }
    
    
    //MARK: - UINavigationControllerDelegate
    
    //Passing selected players to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            if segueKey == "Classes" {
                controller.dictionary["Classes"] = playersClasses
            } else if segueKey == "Other" {
                controller.dictionary[dictionaryName] = dictionary
            }
            controller.viewWillAppear(true)
        }
    }
    
    //MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return false
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        currentRow = textView.tag
        
        //Different options are available for players depending on size of winners and loosers teams.
        //In Avalon, there are always more good guys than bad guys, so I use it to have team-specific classes available only.
        if let winners = winners, let loosers = loosers, game.name == "Avalon", let player = availablePlayers?[currentRow!]{
            if winners.contains(player) {
                if winners.count > loosers.count {
                    picker.tag = 0
                } else {
                    picker.tag = 1
                }
            } else {
                if loosers.count > winners.count {
                    picker.tag = 0
                } else {
                    picker.tag = 1
                }
            }
            if winners.count == loosers.count {
                picker.tag = 2
            }
        }
        picker.reloadAllComponents()
        
        //If the textView is clicked first time, then assign first position from pickerData to textView and dictionary
        if textView.text == "" {
            picker.selectRow(0, inComponent: 0, animated: false)
            if (myPickerDataEvil != nil && myPickerDataGood != nil) && segueKey == "Classes" {
                let player = availablePlayers![currentRow!]
                //If there are good guys
                if picker.tag == 0 {
                    textView.text = myPickerDataGood[0].name
                    playersClasses[player] = myPickerDataGood[0]
                    //If there are evil guys
                } else if picker.tag == 1 {
                    textView.text = myPickerDataEvil[0].name
                    playersClasses[player] = myPickerDataEvil[0]
                }
            } else if segueKey == "Classes" {
                let player = availablePlayers![currentRow!]
                textView.text = myPickerData[0].name
                playersClasses[player] = myPickerData[0]
            } else if segueKey == "Other" {
                let value = dictionaryValues[0]
                textView.text = value
                let key = dictionaryKeys[currentRow!]
                dictionary[key] = value
            }
            //Else go to position of picker data that is alredy chosen in dictionary
        } else if segueKey == "Classes"{
            if let player = availablePlayers?[currentRow!], let playerClass = playersClasses[player] {
                var index = myPickerData.index(of: playerClass)
                
                if (myPickerDataEvil != nil && myPickerDataGood != nil) && picker.tag == 0 {
                    index = myPickerDataGood.index(of: playerClass)
                } else if (myPickerDataEvil != nil && myPickerDataGood != nil) && picker.tag == 1 {
                    index = myPickerDataEvil.index(of: playerClass)
                }
                picker.selectRow(index!, inComponent: 0, animated: false)
            }
        } else if segueKey == "Other" {
            let key = dictionaryKeys[currentRow!]
            let value = dictionary[key] as! String
            let index = dictionaryValues.index(of: value)
            picker.selectRow(index!, inComponent: 0, animated: false)
        }
        return true
    }
    
    //MARK: - UIPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (myPickerDataEvil != nil && myPickerDataGood != nil) && segueKey == "Classes" {
            if picker.tag == 0 {
                return myPickerDataGood.count
            } else if picker.tag == 1 {
                return myPickerDataEvil.count
            }
            return 1
        } else if segueKey == "Classes" {
            return myPickerData.count
        } else if segueKey == "Other" {
            return dictionaryValues.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        if (myPickerDataEvil != nil && myPickerDataGood != nil) {
            if picker.tag == 0 {
                return myPickerDataGood[row].name
            } else if picker.tag == 1 {
                return myPickerDataEvil[row].name
            } else if picker.tag == 2 {
                return "Pick correct amount of players!"
            }
        } else if segueKey == "Classes" {
            return myPickerData[row].name
        } else if segueKey == "Other" {
            return ""
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        //When selected, then update dictionary and textView
        let cell = tableView.cellForRow(at: IndexPath(row: currentRow!, section: 0)) as! AddInfoCell
        
        if (myPickerDataEvil != nil && myPickerDataGood != nil) && segueKey == "Classes" {
            if picker.tag == 0 {
                let player = availablePlayers![currentRow!]
                playersClasses[player] = myPickerDataGood[row]
                cell.rightTextView.text = myPickerDataGood[row].name
            } else if picker.tag == 1 {
                let player = availablePlayers![currentRow!]
                playersClasses[player] = myPickerDataEvil[row]
                cell.rightTextView.text = myPickerDataEvil[row].name
            }
        } else if segueKey == "Classes" {
            let player = availablePlayers![currentRow!]
            playersClasses[player] = myPickerData[row]
            cell.rightTextView.text = myPickerData[row].name
        } else if segueKey == "Other" {
            let value = dictionaryValues[row]
            let key = dictionaryKeys[currentRow!]
            cell.rightTextView.text = value
            dictionary[key] = value
        }
    }
    
    //MARK: - Toolbar
    //Keyboard Toolbar button functions
    
    //When clicked on next it goes to another textField.
    @objc func toolbarNextButton() {
        if let row = currentRow, let nextCell = tableView.cellForRow(at: IndexPath(row: row + 1, section: 0)) as? AddInfoCell {
            let textView = nextCell.rightTextView
            textView.becomeFirstResponder()
            tableView.scrollToRow(at: IndexPath(row: row + 1, section: 0), at: .middle, animated: true)
        } else if let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddInfoCell {
            let textView = firstCell.rightTextView
            textView.becomeFirstResponder()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
        }
    }
    
    @objc func toolbarHideButton() {
        if let row = currentRow, let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AddInfoCell {
            let textView = cell.rightTextView
            textView.resignFirstResponder()
        }
    }
    
}

