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
        
        tableView.register(SelectedGameMatchesCell.self, forCellReuseIdentifier: "SelectedGameMatchesCell")
    }
    
    
    //MARK: - Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedGameMatchesCell") as! SelectedGameMatchesCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "AllMatchesCell", for: indexPath) as! AllMatchesCell
        cell.gameNameLabel.text = matchStore.allMatches[indexPath.row].game!.name
        cell.dateLabel.text = matchStore.allMatches[indexPath.row].date.toString()
        cell.playersLabel.text = playersString(indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchStore.allMatches.count
    }
    
    //Setting correct height of row
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = playersString(indexPath: indexPath).height(withConstrainedWidth: view.frame.width/2 + 10, font: UIFont.systemFont(ofSize: 14)) + 10
        if height > 44 {
            return height
        }
        return 44
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
        }
        
    }
    
    
    //Getting string to put into playersField - depends on game
    func playersString(indexPath: IndexPath) -> String {
        var string = [String]()
        let players = matchStore.allMatches[indexPath.row].players
        if let points = matchStore.allMatches[indexPath.row].playersPoints, let places = matchStore.allMatches[indexPath.row].playersPlaces {
            for (i, player) in players.enumerated() {
                string.append("\(places[i]). \(player.name): \(points[i])")
            }
            return string.joined(separator: ", ")
        }
        return matchStore.allMatches[indexPath.row].players.map{$0.name}.joined(separator: ", ")
    }
}
