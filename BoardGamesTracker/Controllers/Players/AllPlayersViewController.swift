//
//  AllPlayersViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 19/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AllPlayersViewController: UITableViewController, UITextViewDelegate {
    
    var playerStore: PlayerStore!
    var tableHeaderView: AllPlayersHeaderView!
    var addingPlayer = false
    var currentCell: Int?
    
    var toolbar: UIToolbar!
    
    //MARK: - Overriding functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        tableHeaderView.label.text = "You played with \(playerStore.allPlayers.count) friends so far. See their statistics below."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Registering cells so we can use them
        tableView.register(AllPlayersCell.self, forCellReuseIdentifier: "AllPlayersCell")
        tableView.register(AddPlayersCell.self, forCellReuseIdentifier: "AddPlayersCell")
        tableView.rowHeight = 50
        //Adding right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonBar))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode(_:)))
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAddingPlayerButtonPressed))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addPlayer))
        
        toolbar = Constants.Functions.createToolbarWith(leftButton: cancelButton, rightButton: doneButton)
        
        tableView.backgroundColor = Constants.Global.backgroundColor
        
        tableHeaderView = AllPlayersHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70))
        
        tableView.tableHeaderView = tableHeaderView
    }
    
    
    //MARK: - UITableView - conforming etc
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //If we want to add new player, then create additional cell
        if indexPath.row == playerStore.allPlayers.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddPlayersCell", for: indexPath) as! AddPlayersCell
            cell.addButton.addTarget(self, action: #selector(addPlayer), for: .touchUpInside)
            cell.playerName.inputAccessoryView = toolbar
            cell.backgroundColor = UIColor.clear
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllPlayersCell", for: indexPath) as! AllPlayersCell
        cell.playerName.text = playerStore.allPlayers[indexPath.row].name
        
        //Get last time played
        if let lastTimePlayed = playerStore.allPlayers[indexPath.row].lastTimePlayed {
            cell.playerDate.text = lastTimePlayed.toStringWithHour()
        } else {
            cell.playerDate.text = "00-00-0000 00:00"
        }
        
        //How many times played
        let timesPlayed = playerStore.allPlayers[indexPath.row].timesPlayed
        if timesPlayed == 0 {
            cell.playerTimesPlayed.text = "Never played yet"
        } else {
            cell.playerTimesPlayed.text = "\(playerStore.allPlayers[indexPath.row].timesPlayed) times played"
        }
        cell.playerTimesPlayed.textColor = Constants.Global.detailTextColor
        //Make playerName textView editable if table is editing and vice versa
        if isEditing {
            cell.playerName.isEditable = true
            cell.playerName.isUserInteractionEnabled = true
        } else {
            cell.playerName.isEditable = false
            cell.playerName.isUserInteractionEnabled = false
        }
        cell.playerName.delegate = self
        cell.playerName.tag = indexPath.row
        cell.playerName.backgroundColor = UIColor.clear
        if isEditing{
            cell.backgroundView = CellBackgroundEditingView(frame: cell.frame)
        } else {
            cell.backgroundView = CellBackgroundView(frame: cell.frame)
        }
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addingPlayer {
            return playerStore.allPlayers.count + 1
        }
        return playerStore.allPlayers.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < playerStore.allPlayers.count {
            let heightOfName = playerStore.allPlayers[indexPath.row].name.height(withConstrainedWidth: tableView.frame.width - 60, font: UIFont.systemFont(ofSize: 17))
            if let heightOfDate = playerStore.allPlayers[indexPath.row].lastTimePlayed?.toString().height(withConstrainedWidth: tableView.frame.width/2, font: UIFont.systemFont(ofSize: 17)) {
                print(heightOfDate + heightOfName + 10)
                return heightOfDate + heightOfName + 10
            }
        }
        return 52
        
    }
    
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundSelectView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        performSegue(withIdentifier: "showPlayerDetails", sender: indexPath.row)
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
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPlayerDetails"?:
            let index = sender as! Int
            let controller = segue.destination as! PlayerDetailsViewController
            controller.player = playerStore.allPlayers[index]
        default:
            preconditionFailure("Wrong segue identifier")
        }
    }
    
    //MARK: - Adding new players
    
    @IBAction func addButtonBar() {
        if isEditing {
            return
        }
        addingPlayer = true
        tableView.reloadData()
        DispatchQueue.main.async {
            //If add button in bar is touched, then scroll to bottom and make the new cell a first responder
            self.tableView.scrollToRow(at: IndexPath(item: self.playerStore.allPlayers.count, section: 0), at: .top, animated: false)
            let cell = self.tableView.cellForRow(at: IndexPath(item: self.playerStore.allPlayers.count, section: 0)) as! AddPlayersCell
            cell.playerName.becomeFirstResponder()
        }
    }
    
    @IBAction func addPlayer() {
        let cell = tableView.cellForRow(at: IndexPath(item: self.playerStore.allPlayers.count, section: 0)) as! AddPlayersCell
        
        //Cannot create player without name
        if cell.playerName.text == "" {
            
        } else {
            let player = Player(name: cell.playerName.text!)
            playerStore.addPlayer(player)
            addingPlayer = false
            cell.playerName.text = ""
            tableView.reloadData()
        }
    }
    
    
    @objc func cancelAddingPlayerButtonPressed() {
        guard let cell = tableView.cellForRow(at: IndexPath(row: playerStore.allPlayers.count, section: 0)) as? AddPlayersCell else { return }
        addingPlayer = false
        cell.playerName.text = ""
        cell.resignFirstResponder()
        tableView.reloadData()
    }
    
    //MARK: - Deletions
    
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        addingPlayer = false
        tableView.reloadData()
        var name = " "
        //If there is a cell already chosen, then get name of game
        if let row = currentCell, let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? AllPlayersCell {
            name = cell.playerName.text
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
    
    //Deletions
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let player = playerStore.allPlayers[indexPath.row]
            if player.timesPlayed != 0 {
                let alert = Constants.Functions.createAlert(title: "Failure!", message: "You cannot delete player with matches. Delete matches first.")
                let action = UIAlertAction(title: "Ok!", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return
            }
            let title = "Are you sure you want to delete \(player.name)?"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                self.playerStore.removePlayer(player)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Editing
    
    //Update game name if text changes
    func textViewDidChange(_ textView: UITextView) {
        playerStore.allPlayers[textView.tag].name = textView.text
        currentCell = textView.tag
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    //If there is no text in game name TextView, then display alert and do not allow to end editing
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.layoutIfNeeded()
        if textView.text == "" {
            let alert = UIAlertController(title: nil, message: "Player name must have at least 1 character.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
}
