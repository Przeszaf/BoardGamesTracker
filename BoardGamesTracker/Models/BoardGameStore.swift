//
//  BoardGameStore.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class BoardGameStore {
    
    var allBoardGames = [BoardGame]()
    
    func addGame(_ game: BoardGame) {
        allBoardGames.append(game)
    }
    
    @discardableResult func removeGame(_ game: BoardGame) -> BoardGame {
        if let index = allBoardGames.index(of: game) {
            allBoardGames.remove(at: index)
        }
        return game
    }
}
