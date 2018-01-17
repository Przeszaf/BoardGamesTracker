//
//  Match.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class Match {
    var boardGame: BoardGame
    var winners: [Player]
    var loosers: [Player]
    var date: Date
    
    
    init(boardGame: BoardGame, winners: [Player], loosers: [Player]) {
        self.boardGame = boardGame
        self.winners = winners
        self.loosers = loosers
        date = Date()
    }
}
