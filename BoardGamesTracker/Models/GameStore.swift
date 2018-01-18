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
    }
    
    @discardableResult func removeGame(_ game: Game) -> Game {
        if let index = allGames.index(of: game) {
            allGames.remove(at: index)
        }
        return game
    }
}
