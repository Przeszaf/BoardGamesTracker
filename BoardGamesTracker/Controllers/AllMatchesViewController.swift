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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode(_:)))
    }
    
    
    //MARK: - Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedGameMatchesCell") as! SelectedGameMatchesCell
        cell.gameNameLabel.text = matchStore.allMatches[indexPath.row].game!.name
        cell.dateLabel.text = matchStore.allMatches[indexPath.row].date.toString()
        cell.playersLabel.text = playersString(indexPath: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchStore.allMatches.count
    }
    
    //MARK: - UITableViewDelegate
    
    //Setting correct height of row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = playersString(indexPath: indexPath).height(withConstrainedWidth: view.frame.width/2 + 10, font: UIFont.systemFont(ofSize: 14)) + 10
        if height > 44 {
            return height
        }
        return 44
    }
    
    //Deletions
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let match = matchStore.allMatches[indexPath.row]
            let title = "Are you sure you want to delete 1 match of \(match.game!.name)?"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                print("I'm in deletions table view")
                if let index = self.gameStore.allGames.index(of: match.game!) {
                    print("Index is \(index)")
                    self.gameStore.allGames[index].removeMatch(match: match)
                }
                self.matchStore.removeMatch(match)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
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
