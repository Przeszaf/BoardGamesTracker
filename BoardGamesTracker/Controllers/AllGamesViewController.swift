//
//  AllGamesViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 11/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit


class AllGamesViewController: UITableViewController, UITextViewDelegate {
    
    var gameStore: GameStore!
    var matchStore: MatchStore!
    
    var currentCell: Int?
    
    //MARK: - ViewController functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        tableView.register(AllGamesCell.self, forCellReuseIdentifier: "AllGamesCell")
        tableView.rowHeight = 50
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode(_:)))
    }
    
    //MARK: - Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGamesCell", for: indexPath) as! AllGamesCell
        cell.gameName.text = gameStore.allGames[indexPath.row].name
        cell.gameDate.text = gameStore.allGames[indexPath.row].lastTimePlayed?.toStringWithHour()
        cell.gameTimesPlayed.text = "\(gameStore.allGames[indexPath.row].timesPlayed) times played"
        cell.gameName.delegate = self
        cell.gameName.tag = indexPath.row
        if isEditing {
            cell.gameName.isEditable = true
        } else {
            cell.gameName.isEditable = false
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameStore.allGames.count
    }
    
    //MARK: - tableView and textView functions
    
    //Deletions
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let game = gameStore.allGames[indexPath.row]
            let matches = game.matches
            let title = "Are you sure you want to delete \(game.name)?"
            let message = "This will also delete \(matches.count) matches associated with this game."
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                for match in matches {
                    self.matchStore.removeMatch(match)
                }
                self.gameStore.removeGame(game)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //Managing edit of gameName
    
    //Update game name if text changes
    func textViewDidChange(_ textView: UITextView) {
        gameStore.allGames[textView.tag].name = textView.text
        currentCell = textView.tag
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //If there is no text, then display alert and do not allow to end editing
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.layoutIfNeeded()
        if textView.text == "" {
            let alert = UIAlertController(title: nil, message: "Game name must have at least 1 character.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = CGFloat(40 + gameStore.allGames[indexPath.row].name.count)
        print(height)
        return height
    }
    
    //MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addGame"?:
            let addGameController = segue.destination as! AddGameViewController
            addGameController.gameStore = gameStore
        default:
            preconditionFailure("Wrong segue identifier")
        }
    }
    
    //MARK: - Buttons
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        var name = " "
        //If there is a cell already chosen, then get name of game
        if let cell = currentCell {
            name = gameStore.allGames[cell].name
        }
        //If name is null, then do not let end editing mode.
        if isEditing && name != "" {
            setEditing(false, animated: true)
            sender.title = "Edit"
            tableView.reloadData()
        } else {
            setEditing(true, animated: true)
            sender.title = "Done"
            tableView.reloadData()
        }
    }
}
