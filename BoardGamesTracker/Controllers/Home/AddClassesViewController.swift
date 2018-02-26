//
//  AddClassesViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddClassesViewController: UITableViewController, UINavigationControllerDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var picker: UIPickerView!
    
    //Available classes for Avalon game
    let myPickerDataAvalon = [AvalonClasses.GoodServant, AvalonClasses.GoodMerlin, AvalonClasses.GoodPercival, AvalonClasses.BadMinion, AvalonClasses.BadAssassin, AvalonClasses.BadMorgana, AvalonClasses.BadMordred, AvalonClasses.BadOberon]
    
    var game: Game!
    var availablePlayers: [Player]!
    var playersClasses = [Player: Any]()
    var winners: [Player]?
    var loosers: [Player]?
    var toolbar: UIToolbar!
    var currentRow: Int?
    
    
    //MARK: - UITableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        tableView.allowsSelection = false
        tableView.register(AddClassesCell.self, forCellReuseIdentifier: "AddClassesCell")
        
        picker = UIPickerView()
        picker.delegate = self
        
        let leftButton = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(toolbarHideButton))
        let rightButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(toolbarNextButton))
        toolbar = MyToolbar.createToolbarWith(leftButton: leftButton, rightButton: rightButton)
        
        if winners != nil, loosers != nil {
            availablePlayers = winners! + loosers!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    //MARK: - UITableView
    
    //MARK
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddClassesCell", for: indexPath) as! AddClassesCell
        let player = availablePlayers[indexPath.row]
        cell.playerNameLabel.text = player.name
        cell.playerClassTextView.delegate = self
        cell.playerClassTextView.tag = indexPath.row
        cell.playerClassTextView.inputAccessoryView = toolbar
        cell.playerClassTextView.inputView = picker
        if game.name == "Avalon" {
            let classesDictionary = playersClasses as! [Player: AvalonClasses]
            cell.playerClassTextView.text = classesDictionary[player]?.rawValue
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePlayers.count
    }
    
    
    //MARK: - UINavigationControllerDelegate
    
    //Passing selected players to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            controller.playersClasses = playersClasses
            controller.viewWillAppear(true)
        }
    }
    
    //MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return false
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        currentRow = textView.tag
        let player = availablePlayers[currentRow!]
        guard let customGame = game as? CustomGame else { return false }
        
        //Different options are available for players depending on size of winners and loosers teams.
        //In Avalon, there are always more good guys than bad guys, so I use it to have team-specific classes available only.
        if let winners = winners, let loosers = loosers, customGame.name == "Avalon" {
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
            if game.name == "Avalon" {
                if picker.tag == 0 {
                    textView.text = myPickerDataAvalon[0].rawValue
                    playersClasses[player] = myPickerDataAvalon[0]
                } else if picker.tag == 1 {
                    textView.text = myPickerDataAvalon[3].rawValue
                    playersClasses[player] = myPickerDataAvalon[3]
                }
                picker.selectRow(0, inComponent: 0, animated: false)
            }
            //Else go to position of picker data that is alredy chosen in dictionary
        } else if let playerClass = playersClasses[player] as? AvalonClasses {
            var index = myPickerDataAvalon.index(of: playerClass)
            if picker.tag == 1 {
                index = index! - 3
            }
            picker.selectRow(index!, inComponent: 0, animated: false)
        }
        return true
    }
    
    //MARK: - UIPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if game.name == "Avalon" {
            if picker.tag == 0 {
                return 3
            } else if picker.tag == 1 {
                return 5
            }
            return 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        guard let customGame = game as? CustomGame else { return "" }
        if customGame.name == "Avalon" {
            if picker.tag == 0 {
                return myPickerDataAvalon[row].rawValue
            } else if picker.tag == 1 {
                return myPickerDataAvalon[row+3].rawValue
            } else if picker.tag == 2 {
                return "Pick correct amount of players!"
            }
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        //When selected, then update dictionary and textView
        let player = availablePlayers[currentRow!]
        let cell = tableView.cellForRow(at: IndexPath(row: currentRow!, section: 0)) as! AddClassesCell
        
        if game.name == "Avalon" {
            if picker.tag == 0 {
                playersClasses[player] = myPickerDataAvalon[row]
                cell.playerClassTextView.text = myPickerDataAvalon[row].rawValue
            } else if picker.tag == 1 {
                playersClasses[player] = myPickerDataAvalon[row + 3]
                cell.playerClassTextView.text = myPickerDataAvalon[row + 3].rawValue
            }
        }
    }
    
    //MARK: - Toolbar
    //Keyboard Toolbar button functions
    
    //When clicked on next it goes to another textField.
    @objc func toolbarNextButton() {
        if let row = currentRow, let nextCell = tableView.cellForRow(at: IndexPath(row: row + 1, section: 0)) as? AddClassesCell {
            let textView = nextCell.playerClassTextView
            textView.becomeFirstResponder()
            tableView.scrollToRow(at: IndexPath(row: row + 1, section: 0), at: .middle, animated: true)
        } else if let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddClassesCell {
            let textView = firstCell.playerClassTextView
            textView.becomeFirstResponder()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
        }
    }
    
    @objc func toolbarHideButton() {
        if let row = currentRow, let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AddClassesCell {
            let textView = cell.playerClassTextView
            textView.resignFirstResponder()
        }
    }
    
}
