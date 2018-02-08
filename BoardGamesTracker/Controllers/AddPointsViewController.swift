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
    
    
    
    //MARK: - UITableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        tableView.allowsSelection = false
        tableView.register(AddPointsCell.self, forCellReuseIdentifier: "AddPointsCell")
    }
    
    
    //MARK: - UITableView
    
    //MARK
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPointsCell", for: indexPath) as! AddPointsCell
        let player = availablePlayers[indexPath.row]
        cell.playerNameLabel.text = player.name
        if playersPoints[player] == 0 {
            cell.playerPointsField.text = ""
        } else {
            cell.playerPointsField.text = "\(playersPoints[player] ?? 0)"
        }
        cell.playerPointsField.delegate = self
        cell.playerPointsField.tag = indexPath.row
        cell.playerNameLabel.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePlayers.count
    }
    

    //MARK: - UINavigationControllerDelegate
    
    //Passing selected players to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            controller.playersPoints = playersPoints
            _ = controller.sortPlayersPoints(players: &controller.selectedPlayers, order: "ascending")
            controller.updateNames()
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    //Points have to be number between 1 and 999
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let tag = textField.tag
        let person = availablePlayers[tag]
        if (Int(string) != nil && range.upperBound < 3 || string == "" ) {
            let numString = textField.text! + string
            let num = Int(numString)!
            if num >= 1 && num <= 999 {
                if string == "" {
                    playersPoints[person] = num/10
                } else {
                    playersPoints[person] = num
                }
                return true
            }
        }
        return false
    }
    
    

    
    
}
