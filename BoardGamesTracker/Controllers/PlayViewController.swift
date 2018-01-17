//
//  MainMenu.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    
    var boardGameStore: BoardGameStore!
    
    @IBOutlet var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = "Hello Player"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addGame"?:
           let addGameController = segue.destination as! AddGameViewController
            addGameController.boardGameStore = boardGameStore
        case "allGames"?:
            let gamesViewController = segue.destination as! GamesViewController
            gamesViewController.boardGameStore = boardGameStore
        default:
            preconditionFailure("Wrong segue identifier")
            
        }
    }
}
