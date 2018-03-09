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
    var tableHeaderView: GameDetailsHeaderView!
    
    
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
            let averagePointsString = String.init(format: "%.2f", game.averagePoints)
            tableHeaderView.averagePointsLabel.text = "Average points: \(averagePointsString)"
        }
        
        //CHANGE LATER - check
        if let customMatches = game.matches as? [CustomMatch], let customMatch = customMatches.first {
            print("HERE")
            print(customMatch.dictionary ?? "")
            print(customMatch.playersClasses ?? "No players classes")
        }
        
        tableView.backgroundColor = Constants.Global.backgroundColor
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register cell and create button item
        tableView.register(SelectedGameMatchesCell.self, forCellReuseIdentifier: "SelectedGameMatchesCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode(_:)))
        
        
        //Creating game statistics view -
        var height: CGFloat = 90
        if game.type == .SoloWithPoints {
            height = 140
        } else {
            height = 90
        }
        tableHeaderView = GameDetailsHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: height))
        tableView.tableHeaderView = tableHeaderView
    }
    
    
    //MARK: - UITableView
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedGameMatchesCell") as! SelectedGameMatchesCell
        
        //FIXME: use different Cell - Win/Lose instead of game name etc.
        cell.dateLabel.text = game.matches[indexPath.row].date.toStringWithHour()
        
        let match = game.matches[indexPath.row]
        let players = match.players
        cell.playersLabel.text = playersToString(game: game, match: match, players: players)
        
        cell.backgroundColor = UIColor.clear
        if isEditing {
            cell.backgroundView = CellBackgroundEditingView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        } else {
            cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.matches.count
    }
    
    
    //Setting correct height of row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let match = game.matches[indexPath.row]
        let players = match.players
        let string = playersToString(game: game, match: match, players: players)
        let height = string.height(withConstrainedWidth: view.frame.width - 25, font: UIFont.systemFont(ofSize: 17)) + 28
        if height > 44 {
            return height
        }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
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
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundSelectView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundHighlightView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
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
    
    //Getting string to put into playersField
    
    func playersToString(game: Game, match: Match, players: [Player]) -> String {
        var stringArray = [String]()
        for (i, player) in players.enumerated() {
            if game.type == .SoloWithPoints {
                stringArray.append("\(player.name): \(match.playersPoints![i])")
            } else if game.type == .SoloWithPlaces {
                stringArray.append("\(match.playersPlaces![i]). \(player.name)")
            } else if game.type == .TeamWithPlaces {
                if i > 0 {
                    if match.playersPlaces![i-1] == 1 && match.playersPlaces![i] == 2 {
                        stringArray.append("\nLosers: \(player.name)")
                    } else {
                        stringArray.append("\(player.name)")
                    }
                } else {
                    stringArray.append("Winners: \(player)")
                }
            } else if game.type == .Cooperation {
                stringArray.append("\(player.name)")
            }
        }
        var string = stringArray.joined(separator: ", ")
        string = string.replacingOccurrences(of: ", \n", with: "\n")
        return string
        
    }
}
