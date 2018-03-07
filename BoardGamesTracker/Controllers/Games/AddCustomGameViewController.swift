//
//  AddCustomGameViewController.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class AddCustomGameViewController: UITableViewController {
    
    var gameStore: GameStore!
    
    
    //MARK: - ViewController functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CustomGameCell.self, forCellReuseIdentifier: "CustomGameCell")
        navigationItem.title = "Custom games"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMyOwnGame))
        
        tableView.backgroundColor = Constants.Global.backgroundColor
    }
    
    
    //MARK: - TableView
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomGameCell", for: indexPath) as! CustomGameCell
        cell.gameNameLabel.text = gameStore.customGames[indexPath.row].name
        cell.gameTypeLabel.text = "Team game"
        cell.gameIconImageView.image = gameStore.customGames[indexPath.row].gameIcon
        
        cell.backgroundColor = UIColor.clear
        cell.backgroundView = CellBackgroundView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.frame.height))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameStore.customGames.count
    }
    
    //If game is selected, then adds it to allGames in gameStore and removes from customGames
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = gameStore.customGames[indexPath.row]
        gameStore.addGame(game)
        gameStore.customGames.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = gameStore.customGames[indexPath.row].name.height(withConstrainedWidth: tableView.frame.width - 60, font: UIFont.systemFont(ofSize: 17))
        return height + 35
    }
    
    
    
    //MARK: - Segues
    @objc func addMyOwnGame() {
        performSegue(withIdentifier: "addGame", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addGame"?:
            let controller = segue.destination as! AddGameViewController
            controller.gameStore = gameStore
        default:
            preconditionFailure("Wrong segue identifier!")
        }
    }
}
