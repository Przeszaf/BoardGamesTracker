//
//  AddPointsViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 27/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddNumsViewController: UITableViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var availablePlayers: [Player]!
    var playersPoints: [Player: Int]!
    var playersPlaces: [Player: Int]!
    var toolbar: UIToolbar!
    var currentRow: Int?
    
    //Key is used to determine whether this controller is used to assign places or points to players
    var key = ""
    
    //MARK: - UITableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        tableView.allowsSelection = false
        tableView.register(AddNumsCell.self, forCellReuseIdentifier: "AddNumsCell")
        
        
        let leftButton = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(toolbarHideButton))
        let rightButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(toolbarNextButton))
        toolbar = Constants.Functions.createToolbarWith(leftButton: leftButton, rightButton: rightButton)
        
        tableView.backgroundColor = Constants.Global.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if availablePlayers.count != 0 {
            let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! AddNumsCell
            cell.playerNumField.becomeFirstResponder()
        }
    }
    
    
    //MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNumsCell", for: indexPath) as! AddNumsCell
        let player = availablePlayers[indexPath.row]
        
        cell.playerNameLabel.text = player.name
        if key == "Points" {
            if playersPoints[player] != 0 {
                cell.playerNumField.text = "\(playersPoints[player]!)"
            } else {
                cell.playerNumField.text = ""
            }
            cell.playerNumField.placeholder = "Pts"
        } else if key == "Places" {
            if playersPlaces[player] != 0 {
                cell.playerNumField.text = "\(playersPlaces[player]!)"
            } else {
                cell.playerNumField.text = ""
            }
        }
        cell.playerNumField.delegate = self
        cell.playerNumField.tag = indexPath.row
        cell.playerNumField.inputAccessoryView = toolbar
        
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePlayers.count
    }
    

    //MARK: - UINavigationControllerDelegate
    
    //Passing selected players to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            if key == "Points" {
                controller.playersPoints = playersPoints
                _ = controller.sortPlayersPoints(players: &controller.selectedPlayers, pointsDict: playersPoints, order: "ascending")
            } else if key == "Places" {
                controller.playersPlaces = playersPlaces
                controller.sortPlayersPlaces(players: &controller.selectedPlayers, places: controller.playersPlaces)
            }
            controller.viewWillAppear(true)
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    //Points have to be number between 1 and 999
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let tag = textField.tag
        let person = availablePlayers[tag]
        if (Int(string) != nil && range.upperBound < 3 || string == "" ) {
            let numString = textField.text! + string
            var num = Int(numString)!
            if string == "" {
                num = num / 10
            }
            if num >= 0 && num <= 999 && key == "Points" {
                playersPoints[person] = num
                return true
            }
            //Places must be between 1 and count of players.
            if num >= 0 && num <= availablePlayers.count && key == "Places" {
                playersPlaces[person] = num
                return true
            }
        }
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentRow = textField.tag
        return true
    }
    
    //MARK: - Toolbar
    
    //Keyboard Toolbar button functions
    
    //When clicked on next it goes to another textField.
    @objc func toolbarNextButton() {
        if let row = currentRow, let nextCell = tableView.cellForRow(at: IndexPath(row: row + 1, section: 0)) as? AddNumsCell {
            let textField = nextCell.playerNumField
            textField.becomeFirstResponder()
            tableView.scrollToRow(at: IndexPath(row: row + 1, section: 0), at: .middle, animated: true)
        } else if let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddNumsCell {
            let textField = firstCell.playerNumField
            textField.becomeFirstResponder()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
        }
    }
    
    @objc func toolbarHideButton() {
        if let row = currentRow, let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AddNumsCell {
            let textField = cell.playerNumField
            textField.resignFirstResponder()
        }
    }
    
    
}
