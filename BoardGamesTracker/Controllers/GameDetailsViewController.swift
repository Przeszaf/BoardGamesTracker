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
    
    
    //MARK: - Overriding functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SelectedGameMatchesCell.self, forCellReuseIdentifier: "SelectedGameMatchesCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode(_:)))
        
        
        //Creating game statistics view
        let view = GameStatisticsView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 160))
        view.backgroundColor = UIColor.white
        view.totalMatchesLabel.text = "Total matches: 8"
        view.totalPlayersLabel.text = "Total players: 12"
        view.maxPointsLabel.text = "Max points: 23"
        view.minPointsLabel.text = "Min points: 10"
        view.medianPointsLabel.text = "Median points: 15"
        view.averagePointsLabel.text = "Average points: 16.5"
        view.totalTimePlayedLabel.text = "Total time played: 12 hours"
        view.averageTimePlayedLabel.text = "Average time of match: 1h20m"
        tableView.tableHeaderView = view
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
