//
//  ChoosePlayersViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 25/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class ChoosePlayersViewController: UITableViewController, UINavigationControllerDelegate {
    
    var playerStore: PlayerStore!
    
    var selectedPlayers: [Player]!
    
    //MARK: - Overriding UITablViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !selectedPlayers.isEmpty {
            for player in selectedPlayers {
                if let playerIndex = playerStore.allPlayers.index(of: player) {
                    let index = IndexPath(row: playerIndex, section: 0)
                    tableView.selectRow(at: index, animated: false, scrollPosition: .bottom)
                    tableView.cellForRow(at: index)?.accessoryType = UITableViewCellAccessoryType.checkmark
                }
            }
        }
        
    }
    
    //MARK: - Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choosePlayersViewCell", for: indexPath)
        cell.textLabel?.text = playerStore.allPlayers[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerStore.allPlayers.count
    }
    
    //MARK: - Using TableViewDelegate functions
    
    //Making tick marks
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        selectedPlayers.append(playerStore.allPlayers[indexPath.row])
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let player = playerStore.allPlayers[indexPath.row]
        let index = selectedPlayers.index(of: player)
        selectedPlayers.remove(at: index!)
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    //MARK: - Using UINavigationControllerDelegate functions
    
    //Passing selected players to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            controller.selectedPlayers = selectedPlayers
            controller.viewWillAppear(true)
        }
    }
    
}
