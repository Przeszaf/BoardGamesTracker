//
//  Player.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class Player: Equatable, CustomStringConvertible, Hashable, Comparable {
    
    

    //MARK: - Player attributes
    var name: String
    var lastTimePlayed: Date?
    var timesPlayed: Int
    let playerID: String
    var gamesPlayed = [Game]()
    var matchesPlayed = [Game: [Match]]()
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
        self.name = name.capitalized
        lastTimePlayed = nil
        timesPlayed = 0
        playerID = NSUUID().uuidString
    }
    
    
    //MARK: - Functions
    func addMatch(game: Game, match: Match, place: Int?, points: Int?) {
        if game.type == .SoloWithPoints {
            addSoloMatch(game: game, match: match, points: points!, place: place!)
        } else if game.type == .TeamWithPlaces {
            addTeamMatch(game: game, match: match, place: place!)
        }
        timesPlayed += 1
        if let date = lastTimePlayed {
            if date < match.date {
                lastTimePlayed = match.date
            }
        } else {
            lastTimePlayed = match.date
        }
        gamesPlayed.sort()
    }
    
    
    //Team Match with correct values
    private func addTeamMatch(game: Game, match: Match, place: Int) {
        if matchesPlayed[game] == nil {
            gamesPlayed.append(game)
            matchesPlayed[game] = [match]
            gamesPlace[game] = [place]
        } else {
            matchesPlayed[game]?.append(match)
            gamesPlace[game]?.append(place)
        }
    }
    
    //Adds solo match
    private func addSoloMatch(game: Game, match: Match, points: Int, place: Int) {
        if matchesPlayed[game] == nil {
            gamesPlayed.append(game)
            matchesPlayed[game] = [match]
            gamesPlace[game] = [place]
            gamesPoints[game] = [points]
        } else {
            matchesPlayed[game]?.append(match)
            gamesPlace[game]?.append(place)
            gamesPoints[game]?.append(points)
        }
    }
    
    //Removing game
    func removeGame(game: Game) {
        //Gets index of game, count of matches played by player and date of newest game
        if let index = gamesPlayed.index(of: game), let count = matchesPlayed[game]?.count, let date = matchesPlayed[game]?.first?.date {
            gamesPlayed.remove(at: index)
            timesPlayed -= count
            if lastTimePlayed == date {
                if let lastGame = gamesPlayed.first, let lastMatch = matchesPlayed[lastGame]?.first {
                    lastTimePlayed = lastMatch.date
                } else {
                    lastTimePlayed = nil
                }
            }
            matchesPlayed[game] = nil
            gamesPlace[game] = nil
            gamesPoints[game] = nil
        }
    }
    
    func removeMatch(match: Match) {
        let game = match.game!
        if let index = gamesPlayed.index(of: game) {
            if gamesPlayed[index].matches.isEmpty {
                gamesPlayed.remove(at: index)
            }
        }
        if let index = matchesPlayed[game]?.index(of: match) {
            matchesPlayed[game]?.remove(at: index)
            gamesPlace[game]?.remove(at: index)
            gamesPoints[game]?.remove(at: index)
        }
        gamesPlayed.sort()
        if lastTimePlayed == match.date {
            if let lastGame = gamesPlayed.first, let lastMatch = matchesPlayed[lastGame]?.first {
                lastTimePlayed = lastMatch.date
            } else {
                lastTimePlayed = nil
            }
        }
        timesPlayed -= 1
    }
    
    
    //MARK: - Conforming to protocols
    
    //Equatable protocol
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.playerID == rhs.playerID
    }
    
    //Comparable protocol
    static func <(lhs: Player, rhs: Player) -> Bool {
        
        //Player with date should be first
        if rhs.lastTimePlayed == nil && lhs.lastTimePlayed != nil {
            return true
        } else if lhs.lastTimePlayed == nil && rhs.lastTimePlayed != nil {
            return false
        }
        
        //Taking care of inputs with dates
        if let date1 = lhs.lastTimePlayed, let date2 = rhs.lastTimePlayed {
            if date1 > date2 {
                return true
            } else if date1 < date2 {
                return false
            }
        }
        //If the date is the same or there is no dates available, then sort by name
        if lhs.name < rhs.name {
            return true
        }
        return false
    }
}
