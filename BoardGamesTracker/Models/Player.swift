//
//  Player.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class Player: Equatable, CustomStringConvertible, Hashable {
    

    //MARK: - Player attributes
    var name: String
    var lastTimePlayed: Date?
    var timesPlayed: Int
    let playerID: String
    var gamesPlayed = [Game: [Match]]()
    var gamesPlace = [Game: [Int]]()
    var gamesPoints = [Game: [Int]]()
    
    var description: String {
        return name
    }
    
    var hashValue: Int {
        return playerID.hashValue
    }
    
    
    //MARK: - Initializers
    init(name: String) {
        self.name = name
        lastTimePlayed = nil
        timesPlayed = 0
        playerID = NSUUID().uuidString
    }
    
    //MARK: - Functions
    func addTeamMatch(game: Game, match: Match, place: Int) {
        if gamesPlayed[game] == nil {
            gamesPlayed[game] = [match]
            gamesPlace[game] = [place]
        } else {
            gamesPlayed[game]?.append(match)
            gamesPlace[game]?.append(place)
        }
    }
    
    func addSoloMatch(game: Game, match: Match, points: Int, place: Int) {
        if gamesPlayed[game] == nil {
            gamesPlayed[game] = [match]
            gamesPlace[game] = [place]
            gamesPoints[game] = [points]
        } else {
            gamesPlayed[game]?.append(match)
            gamesPlace[game]?.append(place)
            gamesPoints[game]?.append(points)
        }
    }
    
    
    //MARK: - Conforming to protocols
    
    //Equatable protocol
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.playerID == rhs.playerID
    }
}
