//
//  ChooseWinnersViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 26/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class ChooseWinnersViewController: UITableViewController, UINavigationControllerDelegate {
    
    var availablePlayers: [Player]!
    var winners: [Player]!
    
    //MARK: - Overriding UITablViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !winners.isEmpty {
            for winner in winners {
                if let winnerIndex = availablePlayers.index(of: winner) {
                    let index = IndexPath(row: winnerIndex, section: 0)
                    tableView.selectRow(at: index, animated: false, scrollPosition: .bottom)
                    tableView.cellForRow(at: index)?.accessoryType = UITableViewCellAccessoryType.checkmark
                }
            }
        }
        
    }
    
    //MARK: - Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chooseWinnersViewCell", for: indexPath)
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
        winners.append(availablePlayers[indexPath.row])
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let player = availablePlayers[indexPath.row]
        let index = winners.index(of: player)
        winners.remove(at: index!)
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    //MARK: - Using UINavigationControllerDelegate functions
    
    //Passing selected players to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            controller.winners = winners
            controller.viewWillAppear(true)
        }
    }
    
}
