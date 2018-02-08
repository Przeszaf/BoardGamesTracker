//
//  PlayerDetailsViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 06/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class PlayerDetailsViewController: UITableViewController {
    
    var player: Player!
    
    //MARK: - Overriding functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70
        tableView.register(PlayerDetailsCell.self, forCellReuseIdentifier: "PlayerDetailsCell")
    }
    
    
    //MARK: - UITableView
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerDetailsCell", for: indexPath) as! PlayerDetailsCell
        let game = player.gamesPlayed[indexPath.section]
        let playersInMatch = player.matchesPlayed[game]![indexPath.row].players
        print(playersInMatch.map{$0.name}.joined(separator: ", "))
        cell.playersLabel.text = playersInMatch.map{$0.name}.joined(separator: ", ")
        cell.dateLabel.text = player.matchesPlayed[game]?.first?.date.toStringWithHour()
        cell.placeLabel.text = String(player.gamesPlace[game]![indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let game = player.gamesPlayed[section]
        return player.matchesPlayed[game]!.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return player.gamesPlayed.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let game = player.gamesPlayed[section]
        return "\(player.gamesPlayed[section].name) - \(player.matchesPlayed[game]!.count) matches"
    }
    
}
