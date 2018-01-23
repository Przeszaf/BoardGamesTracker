//
//  ChooseGameViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 23/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class ChooseGameViewController: UITableViewController, UINavigationControllerDelegate {
    
    var gameStore: GameStore!
    
    var chosenGame: Game?
    
    //MARK: - Overriding UITablViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = false
        navigationController?.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //If there is chosenGame, then select it
        if let game = chosenGame, let gameIndex = gameStore.allGames.index(of: game) {
            let index = IndexPath(row: gameIndex, section: 0)
            tableView.selectRow(at: index, animated: true, scrollPosition: .bottom)
            tableView.cellForRow(at: index)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
    
    //MARK: - Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chooseGameViewCell", for: indexPath)
        cell.textLabel?.text = gameStore.allGames[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameStore.allGames.count
    }
    
    //MARK: - Using TableViewDelegate functions
    
    //Making tick marks
    override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        chosenGame = gameStore.allGames[indexPath.row]
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    //MARK: - Using UINavigationControllerDelegate functions
    
    //Passing chosen game to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            controller.chosenGame = chosenGame
            controller.viewWillAppear(true)
        }
    }
    
}
