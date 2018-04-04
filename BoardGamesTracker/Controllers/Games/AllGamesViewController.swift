//
//  AllGamesViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 11/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreData


class AllGamesViewController: UITableViewController, UITextViewDelegate {
    
    var games = [Game]()
    var managedContext: NSManagedObjectContext!
    
    var currentCell: Int?
    
    //MARK: - ViewController functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<Game>(entityName: "Game")
        let dateSortDescriptor = NSSortDescriptor(key: "lastTimePlayed", ascending: false)
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [dateSortDescriptor, nameSortDescriptor]
        request.predicate = NSPredicate(format: "inCollection == YES", argumentArray: nil)
        do {
            games = try managedContext.fetch(request)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch: \(error)")
        }
        
        tableView.reloadData()
        reloadHeaderView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(AllGamesCell.self, forCellReuseIdentifier: "AllGamesCell")
        tableView.rowHeight = 50
        tableView.backgroundColor = Constants.Global.backgroundColor
        tableView.separatorStyle = .none
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode(_:)))
        
        
    }
    
    //MARK: - TableView functions
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //If it is custom game, then use different cell style with icon
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGamesCell", for: indexPath) as! AllGamesCell
        let game = games[indexPath.row]
        
        if let lastTimePlayed = game.lastTimePlayed {
            let date = lastTimePlayed as Date
            cell.gameDate.text = date.toStringWithHour()
        }
        cell.gameName.text = game.name
        cell.gameTimesPlayed.text = "\(game.matches?.count ?? 0) times played"
        cell.gameTimesPlayed.textColor = Constants.Global.detailTextColor
        cell.gameName.delegate = self
        cell.selectionStyle = .none
        
        cell.imageView?.image = UIImage(named: game.name!)
        
        //Set tag so we can update gameName when editing
        cell.gameName.tag = indexPath.row
        if isEditing {
            cell.gameName.isEditable = true
            cell.gameName.isUserInteractionEnabled = true
        } else {
            cell.gameName.isEditable = false
            cell.gameName.isUserInteractionEnabled = false
        }
        
        //Change background color of cell to clear
        cell.backgroundColor = UIColor.clear
        if isEditing {
            cell.backgroundView = CellBackgroundEditingView(frame: cell.frame)
        } else {
            cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    
    //Deletions
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let game = games[indexPath.row]
            let matches = game.matches
            let title = "Are you sure you want to delete \(game.name!)?"
            let message = "This will also delete \(matches?.count ?? 0) matches associated with this game."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                Helper.removeGame(game: game)
                self.games.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            alert.addAction(deleteAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //Setting correct height of table - depends on length of game name
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = games[indexPath.row].name?.height(withConstrainedWidth: tableView.frame.width - 60, font: UIFont.systemFont(ofSize: 17)) else { return 50 }
        if let heightOfDate = games[indexPath.row].lastTimePlayed?.toString().height(withConstrainedWidth: tableView.frame.width/2, font: UIFont.systemFont(ofSize: 17)) {
            return height + heightOfDate + 14
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
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundHighlightView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }
    
    //MARK: - TextView functions
    
    //Update game name if text changes
    func textViewDidChange(_ textView: UITextView) {
        games[textView.tag].name = textView.text
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
            //FIXME
        case "addPremadeGame"?:
            let controller = segue.destination as! AddPremadeGameViewController
        case "showGameDetails"?:
            //sender is indexPath.row, so now we can pass correct game to view controller
            let index = sender as! Int
            let controller = segue.destination as! GameDetailsViewController
            controller.game = games[index]
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
    
    //Reloads header view - generates new chart etc.
    func reloadHeaderView() {
        let gamesPlayed = games.count
        var matchesPlayed = 0
        for game in games {
            matchesPlayed += (game.matches?.count)!
        }
        let firstHeaderView = AllPlayersHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
        firstHeaderView.label.text = "You have \(gamesPlayed) games in your collection and played \(matchesPlayed) matches. See your statistics below."
        
        let gamesPlayedCount = { () -> [Int] in
            var array = [Int]()
            for game in games {
                if game.matches?.count != 0 {
                    array.append(game.matches!.count)
                }
            }
            return array
        }()
        
        let gameNames = { () -> [String] in
            var nameArray = [String]()
            for game in self.games {
                if game.matches?.count != 0 {
                    nameArray.append(game.name!)
                }
            }
            return nameArray
        }()
        
        let pieChartView = PieChartView(dataSet: gamesPlayedCount, dataName: gameNames, dataLabels: nil, colorsArray: [UIColor.red, UIColor.blue, UIColor.yellow, UIColor.green], title: "Most popular games", radius: 80, truncating: 90, x: 10, y: firstHeaderView.frame.height, width: tableView.frame.width - 40)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: firstHeaderView.frame.height + pieChartView.frame.height + 10))
        headerView.addSubview(firstHeaderView)
        headerView.addSubview(pieChartView)
        tableView.tableHeaderView = headerView
    }
    
}
