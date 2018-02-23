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
    
    var currentCell: Int?
    
    //MARK: - ViewController functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(AllGamesCell.self, forCellReuseIdentifier: "AllGamesCell")
        tableView.register(CustomGameCell.self, forCellReuseIdentifier: "CustomGameCell")
        tableView.rowHeight = 50
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode(_:)))
    }
    
    //MARK: - TableView functions
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let game = gameStore.allGames[indexPath.row]
        
        //If it is custom game, then use different cell style with icon - CHANGE
        if let customGame = game as? CustomGame {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomGameCell") as! CustomGameCell
            cell.gameNameLabel.text = customGame.name
            cell.gameIconImageView.image = customGame.gameIcon
            cell.gameTypeLabel.text = "Team game"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGamesCell", for: indexPath) as! AllGamesCell
        cell.gameName.text = gameStore.allGames[indexPath.row].name
        cell.gameDate.text = gameStore.allGames[indexPath.row].lastTimePlayed?.toStringWithHour()
        cell.gameTimesPlayed.text = "\(gameStore.allGames[indexPath.row].timesPlayed) times played"
        cell.gameName.delegate = self
        
        //Set tag so we can update gameName when editing
        cell.gameName.tag = indexPath.row
        if isEditing {
            cell.gameName.isEditable = true
            cell.gameName.isUserInteractionEnabled = true
        } else {
            cell.gameName.isEditable = false
            cell.gameName.isUserInteractionEnabled = false
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameStore.allGames.count
    }
    
    
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
                self.gameStore.removeGame(game)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //Setting correct height of table - depends on length of game name
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = gameStore.allGames[indexPath.row].name.height(withConstrainedWidth: tableView.frame.width - 60, font: UIFont.systemFont(ofSize: 17))
        if let heightOfDate = gameStore.allGames[indexPath.row].lastTimePlayed?.toString().height(withConstrainedWidth: tableView.frame.width/2, font: UIFont.systemFont(ofSize: 17)) {
            return height + heightOfDate + 10
        }
        return height + 35
    }
    
    //Perform segue when selects row and if it is not in editing mode
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if !isEditing {
            performSegue(withIdentifier: "showGameDetails", sender: indexPath.row)
            return nil
        }
        return indexPath
    }
    
    //MARK: - TextView functions
    
    //Update game name if text changes
    func textViewDidChange(_ textView: UITextView) {
        gameStore.allGames[textView.tag].name = textView.text
        currentCell = textView.tag
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //If there is no text in game name TextView, then display alert and do not allow to end editing
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //Resign first responder if pressed return
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    //MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addCustomGame"?:
            let controller = segue.destination as! AddCustomGameViewController
            controller.gameStore = gameStore
        case "showGameDetails"?:
            //sender is indexPath.row, so now we can pass correct game to view controller
            let index = sender as! Int
            let controller = segue.destination as! GameDetailsViewController
            controller.game = gameStore.allGames[index]
            controller.gameStore = gameStore
        default:
            preconditionFailure("Wrong segue identifier")
        }
    }
    
    //MARK: - Buttons
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        var name = " "
        //If there is a cell already chosen, then get name of game
        if let row = currentCell, let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AllGamesCell {
            name = cell.gameName.text
        }
        //If name is null, then do not let it end editing mode.
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
