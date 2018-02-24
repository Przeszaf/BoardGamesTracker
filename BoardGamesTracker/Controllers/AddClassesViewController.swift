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
        
        //If the textView is clicked first time, then assign first position from pickerData to textView and dictionary
        if textView.text == "" {
            if game.name == "Avalon" {
                textView.text = myPickerDataAvalon[0].rawValue
                playersClasses[player] = myPickerDataAvalon[0]
                picker.selectRow(0, inComponent: 0, animated: false)
            }
            //Else go to position of picker data that is alredy chosen in dictionary
        } else if let playerClass = playersClasses[player] as? AvalonClasses {
            let index = myPickerDataAvalon.index(of: playerClass)
            picker.selectRow(index!, inComponent: 0, animated: false)
        }
        return true
    }
    
    //MARK: - UIPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myPickerDataAvalon.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        let name = myPickerDataAvalon[row].rawValue
        return name
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        //When selected, then update dictionary and textView
        let player = availablePlayers[currentRow!]
        playersClasses[player] = myPickerDataAvalon[row]
        let cell = tableView.cellForRow(at: IndexPath(row: currentRow!, section: 0)) as! AddClassesCell
        cell.playerClassTextView.text = myPickerDataAvalon[row].rawValue
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
