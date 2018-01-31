//
//  AllGamesViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 11/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit


class AllGamesViewController: UITableViewController {
    
    var gameStore: GameStore!
    
    //MARK: - Overriding functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        tableView.register(AllGamesCell.self, forCellReuseIdentifier: "AllGamesCell")
        tableView.rowHeight = 50
    }
    
    
    //MARK: - Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGamesCell", for: indexPath) as! AllGamesCell
        cell.gameName.text = gameStore.allGames[indexPath.row].name
        cell.gameDate.text = gameStore.allGames[indexPath.row].lastTimePlayed?.toStringWithHour()
        cell.gameTimesPlayed.text = "\(gameStore.allGames[indexPath.row].timesPlayed) times played"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameStore.allGames.count
    }
    
    //MARK: - Managing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addGame"?:
            let addGameController = segue.destination as! AddGameViewController
            addGameController.gameStore = gameStore
        default:
            preconditionFailure("Wrong segue identifier")
        }
    }
}
