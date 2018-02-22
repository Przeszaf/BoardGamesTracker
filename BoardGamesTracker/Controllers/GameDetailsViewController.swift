//
//  AllMatchesViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class GameDetailsViewController: UITableViewController {
    
    var game: Game!
    var gameStore: GameStore!
    var tableHeaderView: GameStatisticsView!
    
    
    //MARK: - Overriding functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableHeaderView.totalMatchesLabel.text = "Total matches: \(game.matches.count)"
        
        var players = [Player]()
        for match in game.matches {
            for player in match.players {
                players.append(player)
            }
        }
        players = Array(Set(players))
        tableHeaderView.totalPlayersLabel.text = "Total players: \(players.count)"
        tableHeaderView.totalTimePlayedLabel.text = "Total time played: \(game.totalTime.toString())"
        tableHeaderView.averageTimePlayedLabel.text = "Average time of match: \(game.averageTime.toString())"
        
        if game.type == .SoloWithPoints {
            tableHeaderView.maxPointsLabel.isHidden = false
            tableHeaderView.minPointsLabel.isHidden = false
            tableHeaderView.medianPointsLabel.isHidden = false
            tableHeaderView.averagePointsLabel.isHidden = false
            
            tableHeaderView.maxPointsLabel.text = "Max points: \(game.pointsArray.last!)"
            tableHeaderView.minPointsLabel.text = "Min points: \(game.pointsArray.first!)"
            
            if game.pointsArray.count % 2 == 1 {
                tableHeaderView.medianPointsLabel.text = "Median points: \(game.pointsArray[game.pointsArray.count/2])"
            } else {
                tableHeaderView.medianPointsLabel.text = "Median points: \((game.pointsArray[game.pointsArray.count/2] + game.pointsArray[game.pointsArray.count/2 - 1]) / 2)"
            }
            tableHeaderView.averagePointsLabel.text = "Average points: \(game.averagePoints)"
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SelectedGameMatchesCell.self, forCellReuseIdentifier: "SelectedGameMatchesCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode(_:)))
        
        
        //Creating game statistics view
        tableHeaderView = GameStatisticsView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 160))
        tableHeaderView.backgroundColor = UIColor.white
        tableView.tableHeaderView = tableHeaderView
    }
    
    
    //MARK: - UITableView
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedGameMatchesCell") as! SelectedGameMatchesCell
        cell.gameNameLabel.text = game.name
        cell.dateLabel.text = game.matches[indexPath.row].date.toStringWithHour()
        cell.playersLabel.text = playersToString(indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.matches.count
    }
    
    
    //Setting correct height of row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = playersToString(indexPath: indexPath).height(withConstrainedWidth: view.frame.width/2 + 10, font: UIFont.systemFont(ofSize: 14)) + 10
        if height > 44 {
            return height
        }
        return 44
    }
    
    //Deletions
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let match = game.matches[indexPath.row]
            let title = "Are you sure you want to delete 1 match of \(match.game!.name)?"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                if let index = self.gameStore.allGames.index(of: match.game!) {
                    self.gameStore.allGames[index].removeMatch(match: match)
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Buttons
    
    //Button set to toggle editing mode
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        if isEditing {
            setEditing(false, animated: true)
            sender.title = "Edit"
            tableView.reloadData()
        } else {
            setEditing(true, animated: true)
            sender.title = "Done"
            tableView.reloadData()
        }
    }
    

    //MARK: - Other
    
    //Getting string to put into playersField - depends on game
    func playersToString(indexPath: IndexPath) -> String {
        var string = [String]()
        let players = game.matches[indexPath.row].players
        if let points = game.matches[indexPath.row].playersPoints, let places = game.matches[indexPath.row].playersPlaces {
            for (i, player) in players.enumerated() {
                string.append("\(places[i]). \(player.name): \(points[i])")
            }
            return string.joined(separator: ", ")
        }
        return game.matches[indexPath.row].players.map{$0.name}.joined(separator: ", ")
    }
}
