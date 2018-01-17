//
//  BoardGame.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class BoardGame: Equatable, CustomStringConvertible {
    
    
    //MARK: Board game attributes
    var name: String
    var maxNoOfPlayers: Int
    var maxNoOfTeams: Int?
    var gameType: String?
    var timesPlayed: Int
    var lastTimePlayed: Date?
    
    let gameId: String
    
    
    //MARK: - Conforming to protocols
    var description: String
    
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
    
    //MARK: - Conforming to protocols
    static func ==(lhs: BoardGame, rhs: BoardGame) -> Bool {
        return lhs.gameId == rhs.gameId
    }
    
    
    
}
