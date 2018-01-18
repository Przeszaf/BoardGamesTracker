//
//  Game.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class Game: Equatable, CustomStringConvertible {
    
    
    //MARK: Board game attributes
    var name: String
    var maxNoOfPlayers: Int
    var maxNoOfTeams: Int?
    var gameType: String?
    var timesPlayed: Int
    var lastTimePlayed: Date?
    let gameId: String
    
    var matches = [Match]()
    
    
    //MARK: - Conforming to protocols
    var description: String
    
    static func ==(lhs: Game, rhs: Game) -> Bool {
        return lhs.gameId == rhs.gameId
    }
    //MARK: - Initializers
    init(name: String, maxNoOfPlayers: Int, maxNoOfTeams: Int?, gameType: String?) {
        gameId = NSUUID().uuidString
        self.name = name
        self.maxNoOfPlayers = maxNoOfPlayers
        self.maxNoOfTeams = maxNoOfTeams
        self.gameType = gameType
        timesPlayed = 0
        lastTimePlayed = nil
        description = "Name: \(name), max number of players: \(maxNoOfPlayers), max number of teams: \(maxNoOfTeams ?? 0), game type: \(gameType ?? "None"), times played: \(timesPlayed)"
    }
    
    
    
    
}
