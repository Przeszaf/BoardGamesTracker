//
//  AddPointsViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 27/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddPointsViewController: UITableViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var availablePlayers: [Player]!
    var playersPoints: [Player: Int]!
    var playersPlaces: [Player: Int]!
    var toolbar: UIToolbar!
    var currentRow: Int?
    
    var key = ""
    
    //MARK: - UITableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        tableView.allowsSelection = false
        tableView.register(AddPointsCell.self, forCellReuseIdentifier: "AddPointsCell")
        
        let leftButton = UIBarButtonItem(title: "Hide", style: .plain, target: self, action: #selector(hideButton))
        let rightButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(doneButton))
        toolbar = MyToolbar.createToolbarWith(leftButton: leftButton, rightButton: rightButton)
    }
    
    
    //MARK: - UITableView
    
    //MARK
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPointsCell", for: indexPath) as! AddPointsCell
        let player = availablePlayers[indexPath.row]
        cell.playerNameLabel.text = player.name
        if key == "Points" {
            if playersPoints[player] != 0 {
                cell.playerPointsField.text = "\(playersPoints[player]!)"
            } else {
                cell.playerPointsField.text = ""
            }
        } else if key == "Places" {
            if playersPlaces[player] != 0 {
                cell.playerPointsField.text = "\(playersPlaces[player]!)"
            } else {
                cell.playerPointsField.text = ""
            }
        }
        cell.playerPointsField.delegate = self
        cell.playerPointsField.tag = indexPath.row
        cell.playerPointsField.inputAccessoryView = toolbar
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
                _ = controller.sortPlayersPoints(players: &controller.selectedPlayers, order: "ascending")
            } else if key == "Places" {
                controller.playersPlaces = playersPlaces
                controller.sortPlayersPlaces(players: &controller.selectedPlayers)
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
            if num >= 1 && num <= 999 && key == "Points" {
                playersPoints[person] = num
                return true
            }
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
    
    //Keyboard Toolbar button functions
    @objc func doneButton() {
        if let row = currentRow, let nextCell = tableView.cellForRow(at: IndexPath(row: row + 1, section: 0)) as? AddPointsCell {
            let textField = nextCell.playerPointsField
            textField.becomeFirstResponder()
            tableView.scrollToRow(at: IndexPath(row: row + 1, section: 0), at: .middle, animated: true)
        } else if let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddPointsCell {
            let textField = firstCell.playerPointsField
            textField.becomeFirstResponder()
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .middle, animated: true)
        }
    }
    
    @objc func hideButton() {
        if let row = currentRow, let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AddPointsCell {
            let textField = cell.playerPointsField
            textField.resignFirstResponder()
        }
    }
    
    
}
