//
//  AllPlayersViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 19/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AllPlayersViewController: UITableViewController {
    
    var playerStore: PlayerStore!
    
    //MARK: - Overriding functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    
    //MARK: - Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerViewCell", for: indexPath)
        cell.textLabel?.text = playerStore.allPlayers[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerStore.allPlayers.count
    }
    
}
