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
    
    
    
    //MARK: - Overriding UITablViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        tableView.allowsSelection = false
    }
    
    
    //MARK: - Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPointsCell", for: indexPath) as! AddPointsCell
        let player = availablePlayers[indexPath.row]
        cell.nameLabel.text = player.name
        if playersPoints[player] == 0 {
            cell.pointsField.text = ""
        } else {
            cell.pointsField.text = "\(playersPoints[player] ?? 0)"
        }
        cell.pointsField.delegate = self
        cell.pointsField.tag = indexPath.row
        cell.nameLabel.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePlayers.count
    }
    

    //MARK: - Using UINavigationControllerDelegate functions
    
    //Passing selected players to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            controller.playersPoints = playersPoints
            _ = controller.sortPlayersPoints(players: &controller.selectedPlayers, order: "ascending")
            controller.updateNames()
        }
    }
    
    //MARK: - Using UITextFieldDelegate functions
    
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
