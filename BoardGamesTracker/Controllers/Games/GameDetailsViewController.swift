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
        
        //Add info about total matches
        tableHeaderView.totalMatchesLabel.text = "Total matches: \(game.matches.count)"
        
        //Calculate amount of unique players that played this game
        var players = [Player]()
        for match in game.matches {
            for player in match.players {
                players.append(player)
            }
        }
        players = Array(Set(players))
        tableHeaderView.totalPlayersLabel.text = "Total players: \(players.count)"
        
        //Get total and average time of match
        tableHeaderView.totalTimePlayedLabel.text = "Total time played: \(game.totalTime.toString())"
        tableHeaderView.averageTimePlayedLabel.text = "Average time of match: \(game.averageTime.toString())"
        
        //For SoloWithPoints game display more information
        if game.type == .SoloWithPoints && game.pointsArray.count != 0 {
            tableHeaderView.maxPointsLabel.isHidden = false
            tableHeaderView.minPointsLabel.isHidden = false
            tableHeaderView.medianPointsLabel.isHidden = false
            tableHeaderView.averagePointsLabel.isHidden = false
            
            //FIXME:  for 0 games there are no max points
            tableHeaderView.maxPointsLabel.text = "Max points: \(game.pointsArray.last!)"
            tableHeaderView.minPointsLabel.text = "Min points: \(game.pointsArray.first!)"
            
            //Calculate Median points
            if game.pointsArray.count % 2 == 1 {
                tableHeaderView.medianPointsLabel.text = "Median points: \(game.pointsArray[game.pointsArray.count/2])"
            } else {
                tableHeaderView.medianPointsLabel.text = "Median points: \((game.pointsArray[game.pointsArray.count/2] + game.pointsArray[game.pointsArray.count/2 - 1]) / 2)"
            }
            tableHeaderView.averagePointsLabel.text = "Average points: \(game.averagePoints)"
        }
        
        //CHANGE LATER - check
        if let customMatches = game.matches as? [CustomMatch], let customMatch = customMatches.first {
            print("HERE")
            print(customMatch.dictionary ?? "")
            print(customMatch.playersClasses ?? "")
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register cell and create button item
        tableView.register(SelectedGameMatchesCell.self, forCellReuseIdentifier: "SelectedGameMatchesCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode(_:)))
        
        
        //Creating game statistics view -
        //FIXME: different height for different types
        tableHeaderView = GameStatisticsView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 160))
        tableHeaderView.backgroundColor = UIColor.white
        tableView.tableHeaderView = tableHeaderView
    }
    
    
    //MARK: - UITableView
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedGameMatchesCell") as! SelectedGameMatchesCell
        
        //FIXME: use different Cell - Win/Lose instead of game name etc.
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
    
    //Getting string to put into playersField - depends on game -
    //FIXME: update for different games
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
