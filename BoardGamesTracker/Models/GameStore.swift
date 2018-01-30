//
//  BoardGameStore.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class GameStore {
    
    //MARK: - Variables
    var allGames = [Game]()
    
    //MARK: - Functions
    func addGame(_ game: Game) {
        allGames.append(game)
        sort()
    }
    
    @discardableResult func removeGame(_ game: Game) -> Game {
        if let index = allGames.index(of: game) {
            allGames.remove(at: index)
        }
        return game
    }
    
    func sort() {
        allGames.sort { (game1, game2) -> Bool in
            if let date1 = game1.lastTimePlayed, let date2 = game2.lastTimePlayed {
                if date1 < date2 {
                    if game1.name < game2.name {
                        return true
                    }
                }
            } else if game1.name < game2.name {
                return true
            }
            return false
        }
    }
}
