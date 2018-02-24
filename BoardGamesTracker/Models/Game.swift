//
//  Game.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class Game: NSObject, Comparable, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(type.rawValue, forKey: "type")
        aCoder.encode(maxNoOfPlayers, forKey: "maxNoOfPlayers")
        aCoder.encode(thereAreTeams, forKey: "thereAreTeams")
        aCoder.encode(thereArePoints, forKey: "thereArePoints")
        aCoder.encode(timesPlayed, forKey: "timesPlayed")
        aCoder.encode(lastTimePlayed, forKey: "lastTimePlayed")
        aCoder.encode(gameID, forKey: "gameID")
        aCoder.encode(matches, forKey: "matches")
        aCoder.encode(pointsArray, forKey: "pointsArray")
        aCoder.encode(averagePoints, forKey: "averagePoints")
        aCoder.encode(totalTime, forKey: "totalTime")
        aCoder.encode(averageTime, forKey: "averageTime")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        type = GameType(rawValue: aDecoder.decodeInteger(forKey: "type"))!
        maxNoOfPlayers = aDecoder.decodeInteger(forKey: "maxNoOfPlayers")
        thereAreTeams = aDecoder.decodeBool(forKey: "thereAreTeams")
        thereArePoints = aDecoder.decodeBool(forKey: "thereArePoints")
        timesPlayed = aDecoder.decodeInteger(forKey: "timesPlayed")
        lastTimePlayed = aDecoder.decodeObject(forKey: "lastTimePlayed") as? Date
        gameID = aDecoder.decodeObject(forKey: "gameID") as! String
        matches = aDecoder.decodeObject(forKey: "matches") as! [Match]
        pointsArray = aDecoder.decodeObject(forKey: "pointsArray") as! [Int]
        averagePoints = aDecoder.decodeDouble(forKey: "averagePoints")
        totalTime = aDecoder.decodeDouble(forKey: "totalTime")
        averageTime = aDecoder.decodeDouble(forKey: "averageTime")
        super.init()
    }
    
    
    //MARK: Board game attributes
    var name: String
    var type: GameType
    var maxNoOfPlayers: Int
    var thereAreTeams: Bool
    var thereArePoints: Bool
    var timesPlayed: Int
    var lastTimePlayed: Date?
    let gameID: String
    var matches = [Match]()
    
    //MARK: - Board game statistics
    var pointsArray = [Int]()
    var averagePoints = 0.0
    var totalTime = TimeInterval(exactly: 0)!
    var averageTime = TimeInterval(exactly: 0)!
    
    
    //MARK: - Conforming to protocols
    //Equatable
    static func ==(lhs: Game, rhs: Game) -> Bool {
        return lhs.gameID == rhs.gameID
    }
    //Hashable
    override var hashValue: Int {
        return gameID.hashValue
    }
    
    
    //Comparable
    static func <(lhs: Game, rhs: Game) -> Bool {
        
        //Game with date should be first
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
    
    //MARK: - Initializers
    init(name: String, type: GameType, maxNoOfPlayers: Int) {
        gameID = NSUUID().uuidString
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
        //Check date, if the match is newer then update it
        if let date = lastTimePlayed {
            if date < match.date {
                lastTimePlayed = match.date
            }
        } else {
            lastTimePlayed = match.date
        }
        timesPlayed += 1
        matches.append(match)
        
        //Add match to each player
        for (i, player) in match.players.enumerated() {
            player.addMatch(game: self, match: match, place: match.playersPlaces?[i], points: match.playersPoints?[i])
        }
        //If there are points, then append pointsArray and sort it
        if let points = match.playersPoints {
            averagePoints = calcAveragePoints(points: points)
            pointsArray += points
        }
        pointsArray.sort()
        //Calculate total and average time of game
        totalTime = totalTime + match.time
        averageTime = totalTime / Double(matches.count)
        print("Total time: \(totalTime), count: \(matches.count), average: \(averageTime)")
    }

    //Removes game and all associated matches
    func removeGame() {
        lastTimePlayed = nil
        for match in matches {
            match.removeGame()
        }
        matches.removeAll()
    }
    
    //Removes single match
    func removeMatch(match: Match) {
        
        //If the newest match was removed, then update date
        if lastTimePlayed == match.date {
            if !matches.isEmpty {
                lastTimePlayed = matches.first!.date
            } else {
                lastTimePlayed = nil
            }
        }
        
        //If it was match with points, then delete it from points array
        //and calculate new average
        if let points = match.playersPoints {
            for point in points {
                let index = pointsArray.index(of: point)
                pointsArray.remove(at: index!)
            }
            averagePoints = calcAveragePoints(points: [])
        }
        
        
        //Remove match from matches list
        if let index = matches.index(of: match) {
            matches.remove(at: index)
        }
        
        //Decrease total time and calculate new average
        totalTime = totalTime - match.time
        averageTime = totalTime / Double(matches.count)
        
        //Calls function removeMatch
        match.removeMatch()
        timesPlayed -= 1
    }
    
    
    //Calculates average points
    func calcAveragePoints(points: [Int]) -> Double {
        var sum = averagePoints * Double(pointsArray.count)
        for point in points {
            sum += Double(point)
        }
        let newAverage = sum / (Double(pointsArray.count) + Double(points.count))
        return newAverage
    }
    
    
}
