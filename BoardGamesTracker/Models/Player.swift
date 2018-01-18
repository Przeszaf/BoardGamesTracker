//
//  Player.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class Player: Equatable {

    //MARK: - Player attributes
    var name: String
    var lastTimePlayed: Date?
    var timesPlayed: Int
    let playerID: String
    
    var gamesPlayed = [String: [String]]()
    
    //MARK: - Initializers
    init(name: String) {
        self.name = name
        lastTimePlayed = nil
        timesPlayed = 0
        playerID = NSUUID().uuidString
    }
    
    //MARK: - Functions
    func addMatch(gameID: String, matchID: String) {
        if gamesPlayed[gameID] == nil {
            gamesPlayed[gameID] = [matchID]
        } else {
            gamesPlayed[gameID]?.append(matchID)
        }
    }
    
    //MARK: - Conforming to protocols
    
    //Equatable protocol
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.playerID == rhs.playerID
    }
}
