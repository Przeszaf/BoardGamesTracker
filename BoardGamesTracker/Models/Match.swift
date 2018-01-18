//
//  Match.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class Match: Equatable {
    //MARK: - Match attributes
    var boardGame: Game
    var winners: [Player]
    var winnersPoints: [Int]?
    var loosers: [Player]
    var loosersPoints: [Int]?
    var date: Date
    
    let matchID: String
    
    //MARK: - Initializers
    init(boardGame: Game, winners: [Player], loosers: [Player]) {
        self.boardGame = boardGame
        self.winners = winners
        self.loosers = loosers
        date = Date()
        matchID = NSUUID().uuidString
    }
    
    //MARK: - Conforming to protocols
    
    //Equatable protocol
    static func ==(lhs: Match, rhs: Match) -> Bool {
        return lhs.matchID == rhs.matchID
    }
    
}
