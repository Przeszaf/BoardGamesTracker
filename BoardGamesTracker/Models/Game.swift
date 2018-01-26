//
//  Game.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class Game: Equatable, Hashable {
    
    
    
    //MARK: Board game attributes
    var name: String
    var maxNoOfPlayers: Int
    var maxNoOfPoints: Int?
    var thereAreTeams: Bool
    var timesPlayed: Int
    var lastTimePlayed: Date?
    let gameId: String
    
    var matches = [Match]()
    
    
    //MARK: - Conforming to protocols
    
    static func ==(lhs: Game, rhs: Game) -> Bool {
        return lhs.gameId == rhs.gameId
    }
    
    var hashValue: Int {
        return gameId.hashValue
    }
    
    //MARK: - Initializers
    init(name: String, maxNoOfPlayers: Int, thereAreTeams: Bool) {
        gameId = NSUUID().uuidString
        self.name = name
        self.maxNoOfPlayers = maxNoOfPlayers
        self.thereAreTeams = thereAreTeams
        timesPlayed = 0
        lastTimePlayed = nil
    }
    
    
    
    
}
