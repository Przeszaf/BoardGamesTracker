//
//  ChooseGameViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 23/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class ChooseGameViewController: UITableViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    var gameStore: GameStore!
    
    var selectedGame: Game?
    
    //MARK: - Overriding UITablViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = false
        navigationController?.delegate = self
        tableView.register(ChooseGameCell.self, forCellReuseIdentifier: "ChooseGameCell")
        tableView.rowHeight = 50
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        If there is selectedGame, then select it
        if let game = selectedGame, let gameIndex = gameStore.allGames.index(of: game) {
            let index = IndexPath(row: gameIndex, section: 0)
            tableView.selectRow(at: index, animated: false, scrollPosition: .bottom)
            tableView.cellForRow(at: index)?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
    
    //MARK: - UITableView
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseGameCell", for: indexPath) as! ChooseGameCell
        cell.gameName.text = gameStore.allGames[indexPath.row].name
        cell.gameDate.text = gameStore.allGames[indexPath.row].lastTimePlayed?.toStringWithHour()
        cell.gameTimesPlayed.text = "\(gameStore.allGames[indexPath.row].timesPlayed) times played"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameStore.allGames.count
    }
    
    //Making tick marks
    override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        selectedGame = gameStore.allGames[indexPath.row]
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    //MARK: - UINavigationControllerDelegate
    
    //Passing chosen game to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            if controller.selectedGame != selectedGame {
                controller.viewDidLoad()
            }
            controller.selectedGame = selectedGame
            controller.viewWillAppear(true)
        }
    }
    
    
    
}
