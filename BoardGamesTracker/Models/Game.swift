//
//  Game.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class Game: Equatable, Hashable, Comparable {
    
    
    
    //MARK: Board game attributes
    var name: String
    var type: GameType
    var maxNoOfPlayers: Int
    var thereAreTeams: Bool
    var thereArePoints: Bool
    var timesPlayed: Int
    var lastTimePlayed: Date?
    let gameId: String
    var matches = [Match]()
    
    //MARK: - Board game statistics
    var pointsArray = [Int]()
    var averagePoints = 0.0
    
    
    //MARK: - Conforming to protocols
    //Equatable
    static func ==(lhs: Game, rhs: Game) -> Bool {
        return lhs.gameId == rhs.gameId
    }
    //Hashable
    var hashValue: Int {
        return gameId.hashValue
    }
    
    
    //Comparable
    static func <(lhs: Game, rhs: Game) -> Bool {
        
        //Game with date should be first
        if rhs.lastTimePlayed == nil && lhs.lastTimePlayed != nil {
            return true
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
    
    //MARK: - Initializers
    init(name: String, type: GameType, maxNoOfPlayers: Int) {
        gameId = NSUUID().uuidString
        self.name = name
        self.type = type
        self.maxNoOfPlayers = maxNoOfPlayers
        timesPlayed = 0
        lastTimePlayed = nil
        if type == .SoloWithPoints {
            thereArePoints = true
            thereAreTeams = false
        } else if type == .TeamWithPlaces {
            thereArePoints = false
            thereAreTeams = true
        } else {
            thereArePoints = false
            thereAreTeams = false
        }
    }
    //MARK: - Functions
    func addMatch(match: Match) {
        if let date = lastTimePlayed {
            if date < match.date {
                lastTimePlayed = match.date
            }
        } else {
            lastTimePlayed = match.date
        }
        timesPlayed += 1
        matches.append(match)
        for (i, player) in match.players.enumerated() {
            player.addMatch(game: self, match: match, place: match.playersPlaces?[i], points: match.playersPoints?[i])
        }
        if let points = match.playersPoints {
            averagePoints = calcAveragePoints(points: points)
            pointsArray += points
        }
        pointsArray.sort()
        print(averagePoints)
    }

    
    func removeGame() {
        lastTimePlayed = nil
        for match in matches {
            match.removeGame()
        }
        matches.removeAll()
    }
    
    func removeMatch(match: Match) {
        if lastTimePlayed == match.date {
            if !matches.isEmpty {
                lastTimePlayed = matches.first!.date
            }
        }
        if let index = matches.index(of: match) {
            matches.remove(at: index)
        }
        match.removeMatch()
        timesPlayed -= 1
    }
    
    
    
    func calcAveragePoints(points: [Int]) -> Double {
        var sum = averagePoints * Double(pointsArray.count)
        for point in points {
            sum += Double(point)
        }
        let newAverage = sum / (Double(pointsArray.count) + Double(points.count))
        return newAverage
    }
    
    
}
