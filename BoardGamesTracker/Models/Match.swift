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
    var game: Game
    var players: [Player]
    var playersPoints: [Int]?
    var playersPlaces: [Int]?
    var date: Date
    
    let matchID: String
    
    //MARK: - Initializers
    init(game: Game, players: [Player], places: [Int]) {
        self.game = game
        self.players = players
        date = Date()
        matchID = NSUUID().uuidString
        playersPlaces = places
    }
    
    init(game: Game, players: [Player], playersPoints: [Int], playersPlaces: [Int]) {
        self.game = game
        self.players = players
        self.playersPoints = playersPoints
        self.playersPlaces = playersPlaces
        date = Date()
        matchID = NSUUID().uuidString
    }
    
    //MARK: - Conforming to protocols
    
    //Equatable protocol
    static func ==(lhs: Match, rhs: Match) -> Bool {
        return lhs.matchID == rhs.matchID
    }
    
    
}
