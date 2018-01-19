//
//  MainMenu.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {
    
    var gameStore: GameStore!
    
    @IBOutlet var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.title = "Hello Player"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addGame"?:
           let addGameController = segue.destination as! AddGameViewController
            addGameController.gameStore = gameStore
        case "allGames"?:
            let gamesViewController = segue.destination as! GamesViewController
            gamesViewController.gameStore = gameStore
        default:
            preconditionFailure("Wrong segue identifier")
            
        }
    }
}
