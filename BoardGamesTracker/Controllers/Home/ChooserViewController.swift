//
//  ChoosePlayersViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 25/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class ChooserViewController: UITableViewController, UINavigationControllerDelegate {
    
    var availablePlayers: [Player]!
    var selectedPlayers: [Player]!
    var deselectedPlayers = [Player]()
    var key: String!
    var maxPlayers: Int?
    var expansions = [String]()
    
    let carcassonneExpansions = [CarcassonneExpansions.Expansion.rawValue, CarcassonneExpansions.ExpansionTwo.rawValue]
    
    //MARK: - UITableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Select players that are passed from previous view controller
        if key == "all" || key == "winners" || key == "loosers" {
            if !selectedPlayers.isEmpty {
                for player in selectedPlayers {
                    if let playerIndex = availablePlayers.index(of: player) {
                        let indexPath = IndexPath(row: playerIndex, section: 0)
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
                        //set tick mark
                        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
                    }
                }
            }
        } else if key == "Carcassonne Expansions" {
            if !expansions.isEmpty {
                for expansion in expansions {
                    if let expansionIndex = carcassonneExpansions.index(of: expansion) {
                        let indexPath = IndexPath(row: expansionIndex, section: 0)
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .bottom)
                        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
                    }
                }
            }
        }
    }
    
    //MARK: - UITableView
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choosePlayersViewCell", for: indexPath)
        if key == "all" || key == "winners" || key == "loosers" {
            cell.textLabel?.text = availablePlayers[indexPath.row].name
        } else if key == "Carcassonne Expansions" {
            cell.textLabel?.text = carcassonneExpansions[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if key == "all" || key == "winners" || key == "loosers" {
            return availablePlayers.count
        } else if key == "Carcassonne Expansions" {
            return carcassonneExpansions.count
        }
        return 0
    }
    
    //MARK: - Using TableViewDelegate functions
    
    //Making tick marks
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if key == "all" || key == "winners" || key == "loosers" {
            let player = availablePlayers[indexPath.row]
            selectedPlayers.append(player)
            if let index = deselectedPlayers.index(of: player) {
                deselectedPlayers.remove(at: index)
            }
        } else if key == "Carcassonne Expansions" {
            let expansion = carcassonneExpansions[indexPath.row]
            expansions.append(expansion)
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if key == "all" || key == "winners" || key == "loosers" {
            let player = availablePlayers[indexPath.row]
            let index = selectedPlayers.index(of: player)
            selectedPlayers.remove(at: index!)
            deselectedPlayers.append(player)
        } else if key == "Carcassonne Expansions" {
            let expansion = carcassonneExpansions[indexPath.row]
            let index = expansions.index(of: expansion)
            expansions.remove(at: index!)
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    //MARK: - UINavigationControllerDelegate
    
    //Passing selected players to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            switch key {
            case "all"?:
                controller.selectedPlayers = selectedPlayers.sorted()
                controller.deselectedPlayers = deselectedPlayers.sorted()
                controller.updateDictionary()
            case "winners"?:
                controller.winners = selectedPlayers.sorted()
            case "loosers"?:
                controller.loosers = selectedPlayers.sorted()
            case "Carcassonne Expansions"?:
                controller.dictionary["Expansions"] = expansions
            default:
                preconditionFailure("Wrong key!")
            }
            controller.viewWillAppear(true)
        }
    }
    
}
