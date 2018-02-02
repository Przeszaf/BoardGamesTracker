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
    var addingPlayer = false
    
    //MARK: - Overriding functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(AllPlayersCell.self, forCellReuseIdentifier: "AllPlayersCell")
        tableView.register(AddPlayersCell.self, forCellReuseIdentifier: "AddPlayersCell")
        tableView.rowHeight = 50
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButton))
        
        let view = UIView(frame: CGRect(x: 50, y: 100, width: tableView.frame.width, height: 300))
        view.backgroundColor = UIColor.lightGray
        let label = UILabel(frame: CGRect(x: 50, y: 0, width: 100, height: 40))
        label.text = "STATISTICS"
        view.addSubview(label)
        tableView.tableHeaderView = view
    }
    
    
    //MARK: - Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == playerStore.allPlayers.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddPlayersCell", for: indexPath) as! AddPlayersCell
            cell.addButton.addTarget(self, action: #selector(addPlayer), for: .touchUpInside)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllPlayersCell", for: indexPath) as! AllPlayersCell
        cell.playerName.text = playerStore.allPlayers[indexPath.row].name
        if let lastTimePlayed = playerStore.allPlayers[indexPath.row].lastTimePlayed {
            cell.playerDate.text = lastTimePlayed.toStringWithHour()
        } else {
            cell.playerDate.text = "0000-00-00"
        }
        let timesPlayed = playerStore.allPlayers[indexPath.row].timesPlayed
        if timesPlayed == 0 {
            cell.playerTimesPlayed.text = "Never played yet"
        } else {
            cell.playerTimesPlayed.text = "\(playerStore.allPlayers[indexPath.row].timesPlayed) times played"
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addingPlayer {
            return playerStore.allPlayers.count + 1
        }
        return playerStore.allPlayers.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        default:
            preconditionFailure("Wrong segue identifier")
        }
    }
    
    @IBAction func addPlayer() {
        let cell = tableView.cellForRow(at: IndexPath(item: self.playerStore.allPlayers.count, section: 0)) as! AddPlayersCell
        if cell.playerName.text == "" {
            
        } else {
            let player = Player(name: cell.playerName.text!)
            playerStore.addPlayer(player)
            playerStore.allPlayers.sort()
            addingPlayer = false
            cell.playerName.text = ""
            tableView.reloadData()
        }
    }
    
    @IBAction func addButton() {
        addingPlayer = true
        tableView.reloadData()
        DispatchQueue.main.async {
            self.tableView.scrollToRow(at: IndexPath(item: self.playerStore.allPlayers.count - 1, section: 0), at: .top, animated: false)
            let cell = self.tableView.cellForRow(at: IndexPath(item: self.playerStore.allPlayers.count, section: 0)) as! AddPlayersCell
            cell.playerName.becomeFirstResponder()
        }
    }
}
