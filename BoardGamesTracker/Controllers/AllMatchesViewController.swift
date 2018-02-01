//
//  AllMatchesViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AllMatchesViewController: UITableViewController {
    
    var matchStore: MatchStore!
    var gameStore: GameStore!
    var playerStore: PlayerStore!
    
    
    //MARK: - Overriding functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    
    //MARK: - Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMatchesCell", for: indexPath) as! AllMatchesCell
        cell.gameNameLabel.text = matchStore.allMatches[indexPath.row].game.name
        cell.dateLabel.text = matchStore.allMatches[indexPath.row].date.toString()
        
        var string = [String]()
        let players = matchStore.allMatches[indexPath.row].players
        if let points = matchStore.allMatches[indexPath.row].playersPoints {
            for (i, player) in players.enumerated() {
                string.append("\(player.name): \(points[i])")
            }
            cell.playersLabel.text = string.joined(separator: ", ")
        } else {
            cell.playersLabel.text = matchStore.allMatches[indexPath.row].players.map{$0.name}.joined(separator: ", ")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchStore.allMatches.count
    }
    
        
    //MARK: - Managing segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addMatch"?:
            let addMatchController = segue.destination as! AddMatchViewController
            addMatchController.gameStore = gameStore
            addMatchController.matchStore = matchStore
            addMatchController.playerStore = playerStore
        default:
            preconditionFailure("Wrong segue identifier")
        }    }
}
