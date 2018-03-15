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
        
        reloadHeaderView()
        
        tableView.backgroundColor = Constants.Global.backgroundColor
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register cell and create button item
        tableView.register(SelectedGameMatchesCell.self, forCellReuseIdentifier: "SelectedGameMatchesCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode(_:)))
    }
    
    
    //MARK: - UITableView
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedGameMatchesCell") as! SelectedGameMatchesCell
        
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
    
    //Assigns backgroundView, because cell height might be different than when initialising cell.
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
    
    
    //Sets correct background views for cell
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
    
    //Getting string to put into playersField. Depends on game type.
    func playersToString(game: Game, match: Match, players: [Player]) -> String {
        var stringArray = [String]()
        for (i, player) in players.enumerated() {
            if game.type == .SoloWithPoints {
                stringArray.append("\(player.name): \(match.playersPoints![i])")
            } else if game.type == .SoloWithPlaces {
                stringArray.append("\(match.playersPlaces![i]). \(player.name)")
            } else if game.type == .TeamWithPlaces {
                if i > 0 {
                    //Detects when players change from winning to losing
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
        
        //Delete coma after all winners
        string = string.replacingOccurrences(of: ", \n", with: "\n")
        return string
    }
    
    func reloadHeaderView() {
        
        //Creating game statistics view -
        var height: CGFloat = 90
        if game.type == .SoloWithPoints {
            height = 100
        } else {
            height = 65
        }
        let firstHeaderView = GameDetailsHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: height))
        
        
        //Add info about total matches
        firstHeaderView.totalMatchesLabel.text = "Total matches: \(game.matches.count)"
        
        //Calculate amount of unique players that played this game
        var players = [Player]()
        for match in game.matches {
            for player in match.players {
                players.append(player)
            }
        }
        players = Array(Set(players))
        firstHeaderView.totalPlayersLabel.text = "Total players: \(players.count)"
        
        //Get total and average time of match
        firstHeaderView.totalTimePlayedLabel.text = "Total time played: \(game.totalTime.toString())"
        firstHeaderView.averageTimePlayedLabel.text = "Average time of match: \(game.averageTime.toString())"
        
        //For SoloWithPoints game display more information
        if game.type == .SoloWithPoints && game.pointsArray.count != 0 {
            firstHeaderView.maxPointsLabel.isHidden = false
            firstHeaderView.minPointsLabel.isHidden = false
            firstHeaderView.averageWinningPointsLabel.isHidden = false
            firstHeaderView.averagePointsLabel.isHidden = false
            
            firstHeaderView.maxPointsLabel.text = "Max points: \(game.pointsArray.last!)"
            firstHeaderView.minPointsLabel.text = "Min points: \(game.pointsArray.first!)"
            
            let averageWinningPoints = { () -> Float in
                var points = 0
                var count = 0
                for match in self.game.matches {
                    guard let winningPoint = match.playersPoints?.first else { return 0 }
                    points += winningPoint
                    count += 1
                }
                return Float(points) / Float(count)
            }()
            
            //Change string format to have 2 decimal places only.
            let averageWinningPointsString = String.init(format: "%.2f%", averageWinningPoints)
            let averagePointsString = String.init(format: "%.2f", game.averagePoints)
            firstHeaderView.averagePointsLabel.text = "Average points: \(averagePointsString)"
            firstHeaderView.averageWinningPointsLabel.text = "Average winning points: \(averageWinningPointsString)"
        }
        
        //Game-specific data
        //FIXME: - with new data build it can be done better
        if game.name == "Avalon" {
            var dataSet = [Int](repeatElement(0, count: 3))
            for match in game.matches {
                if let winnerID = match.players.first?.playerID, let classesDictionary = match.dictionary["Classes"] as? [String: String], let winnerClass = classesDictionary[winnerID] {
                    print(winnerClass)
                    if winnerClass.contains("Arthur") || winnerClass.contains("Merlin") || winnerClass.contains("Percival") {
                        dataSet[0] += 1
                    } else if match.dictionary["Killed by Assassin?"] as! Bool == true {
                        dataSet[2] += 1
                    } else {
                        dataSet[1] += 1
                    }
                }
            }
            
            let secondHeaderView = GameDetailsPieChartView(frame: CGRect.init(x: 0, y: firstHeaderView.frame.height + 5, width: tableView.frame.width, height: 240), dataSet: dataSet, dataName: ["Good", "Evil", "Assassin"])
            let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: firstHeaderView.frame.height + secondHeaderView.frame.height + 20))
            tableHeaderView.addSubview(firstHeaderView)
            tableHeaderView.addSubview(secondHeaderView)
            tableView.tableHeaderView = tableHeaderView
        }
        else if game.type == .SoloWithPoints && !game.pointsArray.isEmpty {
            let secondHeaderView = GameDetailsPointsBarView(frame: CGRect.init(x: 0, y: firstHeaderView.frame.height + 5, width: tableView.frame.width, height: 200), dataSet: game.pointsArray)
            let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: firstHeaderView.frame.height + secondHeaderView.frame.height + 20))
            tableHeaderView.addSubview(firstHeaderView)
            tableHeaderView.addSubview(secondHeaderView)
            tableView.tableHeaderView = tableHeaderView
        } else {
            let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: firstHeaderView.frame.height))
            tableHeaderView.addSubview(firstHeaderView)
            tableView.tableHeaderView = tableHeaderView
        }
        
        
        
    }
}
