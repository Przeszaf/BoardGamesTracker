//
//  ChooseGameViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 23/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class ChooseGameViewController: UITableViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    var gameStore: GameStore!
    
    var selectedGame: Game?
    
    //MARK: - Overriding UITablViewController functions
    override func viewDidLoad() {
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
        
//        If there is selectedGame, then select it
        if let game = selectedGame, let gameIndex = gameStore.allGames.index(of: game) {
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
        let game = gameStore.allGames[indexPath.row]
        cell.gameName.text = game.name
        cell.gameDate.text = game.lastTimePlayed?.toStringWithHour()
        cell.gameTimesPlayed.text = "\(game.timesPlayed) times played"
        if let customGame = game as? CustomGame {
            cell.gameIconImageView.image = customGame.gameIcon
        } else {
            cell.gameIconImageView.image = game.createdIcon
        }
        
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
        return gameStore.allGames.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //Making tick marks
    override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        selectedGame = gameStore.allGames[indexPath.row]
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
