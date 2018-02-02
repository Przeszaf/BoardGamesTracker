//
//  Match.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class Match: Equatable, Comparable {
    
    //MARK: - Match attributes
    var game: Game?
    var players: [Player]
    var playersPoints: [Int]?
    var playersPlaces: [Int]?
    var date: Date
    
    let matchID: String
    
    //MARK: - Initializers
    
    init(game: Game, players: [Player], playersPoints: [Int]?, playersPlaces: [Int]?) {
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
    
    //Comparable protocol
    static func <(lhs: Match, rhs: Match) -> Bool {
        
        //Taking care of inputs with dates
        if lhs.date > rhs.date {
            return true
        } else if lhs.date < rhs.date {
            return false
        }
        //If the date is the same, then sort by name
        if lhs.game!.name < rhs.game!.name {
            return true
        }
        return false
    }
    
    //MARK: - Functions
    func removeGame() {
        for player in players {
            player.removeGame(game: game!)
        }
        players.removeAll()
        game = nil
    }
    
}
