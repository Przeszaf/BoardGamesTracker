//
//  ChooseGameViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 23/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreData

class ChooseGameViewController: UITableViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    var games = [Game]()
    var selectedGame: Game?
    
    var managedContext: NSManagedObjectContext!
    
    
    
    //MARK: - Lifecycle of VC
    override func viewDidLoad() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = false
        navigationController?.delegate = self
        tableView.register(AllGamesCell.self, forCellReuseIdentifier: "AllGamesCell")
        tableView.rowHeight = 50
        
        tableView.backgroundColor = Constants.Global.backgroundColor
        tableView.separatorStyle = .none
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Fetch all games
        do {
            games = try managedContext.fetch(Game.fetchRequest())
        } catch {
            print(error)
        }
        
        //If there is selected game already, then select it
        if let game = selectedGame, let gameIndex = games.index(of: game) {
            let index = IndexPath(row: gameIndex, section: 0)
            tableView.selectRow(at: index, animated: false, scrollPosition: .bottom)
            guard let cell = tableView.cellForRow(at: index) else { return }
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            cell.backgroundView = CellBackgroundSelectView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        }
    }
    
    //MARK: - UITableView
    
    //Conforming to UITableViewDataSource protocol
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGamesCell", for: indexPath) as! AllGamesCell
        let game = games[indexPath.row]
        cell.gameName.text = game.name!
        cell.gameDate.text = game.lastTimePlayed?.toStringWithHour()
        cell.gameTimesPlayed.text = "\(game.matches?.count ?? 0) times played"
        cell.gameTimesPlayed.textColor = Constants.Global.detailTextColor
        
        cell.gameIconImageView.image = UIImage(named: game.name!)
        
        //Added so clicking on gameName will be registered as clicking on cell
        cell.gameName.isEditable = false
        cell.gameName.isUserInteractionEnabled = false
        
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
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = games[indexPath.row].name!.height(withConstrainedWidth: tableView.frame.width - 60, font: UIFont.systemFont(ofSize: 17))
        if let heightOfDate = games[indexPath.row].lastTimePlayed?.toString().height(withConstrainedWidth: tableView.frame.width/2, font: UIFont.systemFont(ofSize: 17)) {
            return height + heightOfDate + 14
        }
        return height + 35
    }
    
    //Making tick marks and correct background view
    override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        selectedGame = games[indexPath.row]
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundSelectView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        cell.accessoryType = UITableViewCellAccessoryType.checkmark
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.none
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundHighlightView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }
    
    override func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
    }
    
    
    
    //MARK: - UINavigationControllerDelegate
    
    //Passing chosen game to previous View Controller
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? AddMatchViewController {
            if controller.selectedGame != selectedGame {
                controller.viewDidLoad()
            }
            controller.selectedGame = selectedGame
            controller.viewWillAppear(true)
        }
    }
    
    
    
}

