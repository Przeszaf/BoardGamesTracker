//
//  ChoosePlayersViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 25/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class ChoosePlayersViewController: UITableViewController, UINavigationControllerDelegate {
    
    var availablePlayers: [Player]!
    var selectedPlayers: [Player]!
    var deselectedPlayers = [Player]()
    var key: String?
    var maxPlayers: Int?
    
    //MARK: - UITableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Select players that are passed from previous view controller
        if !selectedPlayers.isEmpty {
            for player in selectedPlayers {
                if let playerIndex = availablePlayers.index(of: player) {
                    let index = IndexPath(row: playerIndex, section: 0)
                    tableView.selectRow(at: index, animated: false, scrollPosition: .bottom)
                    //set tick mark
                    tableView.cellForRow(at: index)?.accessoryType = UITableViewCellAccessoryType.checkmark
                }
            }
        }
        
    }
    
    //MARK: - UITableView
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choosePlayersViewCell", for: indexPath)
        cell.textLabel?.text = availablePlayers[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availablePlayers.count
    }
    
    //MARK: - Using TableViewDelegate functions
    
    //Making tick marks
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let player = availablePlayers[indexPath.row]
        selectedPlayers.append(player)
        if let index = deselectedPlayers.index(of: player) {
            deselectedPlayers.remove(at: index)
        }
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let player = availablePlayers[indexPath.row]
        let index = selectedPlayers.index(of: player)
        selectedPlayers.remove(at: index!)
        deselectedPlayers.append(player)
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
            default:
                preconditionFailure("Wrong key!")
            }
            controller.viewWillAppear(true)
        }
    }
    
}
