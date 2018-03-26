//
//  AllPlayersViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 19/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreData

class AllPlayersViewController: UITableViewController, UITextViewDelegate {
    
    var players = [Player]()
    var addingPlayer = false
    var currentCell: Int?
    
    var managedContext: NSManagedObjectContext!
    
    var toolbar: UIToolbar!
    
    //MARK: - Overriding functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Player>(entityName: "Player")
        let sortByDate = NSSortDescriptor(key: "lastTimePlayed", ascending: false)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortByDate, sortByName]
        do {
            players = try managedContext.fetch(request)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch: \(error)")
        }
        
        reloadHeaderView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Registering cells so we can use them
        tableView.register(AllPlayersCell.self, forCellReuseIdentifier: "AllPlayersCell")
        tableView.register(AddPlayersCell.self, forCellReuseIdentifier: "AddPlayersCell")
        tableView.rowHeight = 50
        //Adding right and left bar buttons
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonBar))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode(_:)))
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAddingPlayerButtonPressed))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addPlayer))
        
        toolbar = Constants.Functions.createToolbarWith(leftButton: cancelButton, rightButton: doneButton)
        
        tableView.backgroundColor = Constants.Global.backgroundColor
        
        
    }
    
    
    //MARK: - UITableView - conforming etc
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //If we want to add new player, then create additional cell
        if indexPath.row == players.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddPlayersCell", for: indexPath) as! AddPlayersCell
            cell.addButton.addTarget(self, action: #selector(addPlayer), for: .touchUpInside)
            cell.playerName.inputAccessoryView = toolbar
            cell.backgroundColor = UIColor.clear
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllPlayersCell", for: indexPath) as! AllPlayersCell
        cell.playerName.text = players[indexPath.row].name
        
        //Get last time played
        if let lastTimePlayed = players[indexPath.row].lastTimePlayed {
            cell.playerDate.text = lastTimePlayed.toStringWithHour()
        } else {
            cell.playerDate.text = "00-00-0000 00:00"
        }
        
        //How many times played
        let timesPlayed = players[indexPath.row].matches?.count
        if timesPlayed == 0 || timesPlayed == nil {
            cell.playerTimesPlayed.text = "Never played yet"
        } else {
            cell.playerTimesPlayed.text = "\(timesPlayed!) times played"
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
            return players.count + 1
        }
        return players.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < players.count {
            guard let heightOfName = players[indexPath.row].name?.height(withConstrainedWidth: tableView.frame.width - 60, font: UIFont.systemFont(ofSize: 17)) else { return 52 }
            if let heightOfDate = players[indexPath.row].lastTimePlayed?.toString().height(withConstrainedWidth: tableView.frame.width/2, font: UIFont.systemFont(ofSize: 17)) {
                return heightOfDate + heightOfName + 10
            }
        }
        return 52
    }
    
    //Updating cell background view when selected, deselected, highlighted, unhighlighted
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
            controller.player = players[index]
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
            self.tableView.scrollToRow(at: IndexPath(item: self.players.count, section: 0), at: .top, animated: false)
            let cell = self.tableView.cellForRow(at: IndexPath(item: self.players.count, section: 0)) as! AddPlayersCell
            cell.playerName.becomeFirstResponder()
        }
    }
    
    @IBAction func addPlayer() {
        let cell = tableView.cellForRow(at: IndexPath(item: self.players.count, section: 0)) as! AddPlayersCell
        
        //Cannot create player without name
        if cell.playerName.text == "" {
            
        } else {
            let newPlayer = Player(context: managedContext)
            newPlayer.name = cell.playerName.text
            players.append(newPlayer)
            addingPlayer = false
            cell.playerName.text = ""
            
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
            tableView.reloadData()
//            reloadHeaderView()
        }
    }
    
    
    @objc func cancelAddingPlayerButtonPressed() {
        guard let cell = tableView.cellForRow(at: IndexPath(row: players.count, section: 0)) as? AddPlayersCell else { return }
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
            let player = players[indexPath.row]
            if player.matches?.count != 0 {
                let alert = Constants.Functions.createAlert(title: "Failure!", message: "You cannot delete player with matches. Delete matches first.")
                let action = UIAlertAction(title: "Ok!", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return
            }
            let title = "Are you sure you want to delete \(player.name!)?"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                //FIXME: Deletions
                do {
                    self.managedContext.delete(player)
                    try self.managedContext.save()
                } catch {
                    print("Error deleting player. \(error)")
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Editing
    
    //Update game name if text changes
    func textViewDidChange(_ textView: UITextView) {
        players[textView.tag].name = textView.text
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
    
    
    func reloadHeaderView() {
        let playersSortedByActivity = players.sorted(by: { (firstPlayer, secondPlayer) -> Bool in
            if let firstPlayerCount = firstPlayer.matches?.count, let secondPlayerCount = secondPlayer.matches?.count {
                return firstPlayerCount > secondPlayerCount
            } else if secondPlayer.matches?.anyObject() == nil {
                return true
            } else {
                return false
            }
            })
        
        let dataSetMapped = playersSortedByActivity.map({$0.matches?.count ?? 0})

        let dataName = playersSortedByActivity.map({$0.name!})

        var viewsToAdd = [UIView]()

        let firstHeaderView = AllPlayersHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
        firstHeaderView.label.text = "You played with \(players.count) friends! See their statistics below!"
        viewsToAdd.append(firstHeaderView)

        if !dataSetMapped.isEmpty {
            let barChartView = BarChartView(dataSet: nil, dataSetMapped: dataSetMapped, newDataSet: nil, xAxisLabels: dataName, barGapWidth: 4, reverse: true, labelsRotated: true, truncating: 8, title: "Most active players", frame: CGRect.init(x: 0, y: viewsToAdd.last!.frame.height + 10, width: tableView.frame.width, height: 200))
            viewsToAdd.append(barChartView)
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: viewsToAdd.last!.frame.maxY + 15))
        for viewToAdd in viewsToAdd {
            headerView.addSubview(viewToAdd)
        }
        tableView.tableHeaderView = headerView
    }
    
    
}
