//
//  Game.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class Game: NSObject, Comparable, NSCoding {
    
    
    //MARK: Board game attributes
    var name: String
    let gameID: String
    var maxNoOfPlayers: Int
    var icon: UIImage?
    
    var thereAreTeams: Bool
    var thereArePoints: Bool
    var type: GameType
    var pointsExtendedNameArray: [String]?
    var classesArray: [String]?
    var evilClassesArray: [String]?
    var goodClassesArray: [String]?
    var expansionsArray: [String]?
    var expansionsAreMultiple: Bool?
    var scenariosArray: [String]?
    var scenariosAreMultiple: Bool?
    var winSwitch: Bool?
    var difficultyNames: [String]?
    var roundsLeftName: String?
    var additionalSwitchName: String?
    var additionalSecondSwitchName: String?
    var dictionary: [String: Any]?
    
    //Derived later
    var timesPlayed: Int
    var lastTimePlayed: Date?
    var matches = [Match]()
    var pointsArray = [Int]()
    var averagePoints: Float {
        var sum: Float = 0
        for point in pointsArray {
            sum += Float(point)
        }
        return sum / Float(pointsArray.count)
    }
    var totalTime = TimeInterval(exactly: 0)!
    var averageTime = TimeInterval(exactly: 0)!
    
    
    //MARK: - Initializers
    init(name: String, type: GameType, maxNoOfPlayers: Int) {
        gameID = NSUUID().uuidString
        self.name = name.capitalized
        self.maxNoOfPlayers = maxNoOfPlayers
        self.type = type
        
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
        
        timesPlayed = 0
        lastTimePlayed = nil
        if let iconImage = UIImage(named: name) {
            icon = iconImage
        }
        super.init()
    }
    
    convenience init(name: String, type: GameType, maxNoOfPlayers: Int, pointsExtendedNameArray: [String]?, classesArray: [String]?, goodClassesArray: [String]?, evilClassesArray: [String]?, expansionsArray: [String]?, expansionsAreMultiple: Bool?, scenariosArray: [String]?, scenariosAreMultiple: Bool?, winSwitch: Bool?, difficultyNames: [String]?, roundsLeftName: String?, additionalSwitchName: String?, additionalSecondSwitchName: String?) {
        self.init(name: name, type: type, maxNoOfPlayers: maxNoOfPlayers)
        self.pointsExtendedNameArray = pointsExtendedNameArray
        self.classesArray = classesArray
        self.goodClassesArray = goodClassesArray
        self.evilClassesArray = evilClassesArray
        self.expansionsArray = expansionsArray
        self.expansionsAreMultiple = expansionsAreMultiple
        self.scenariosArray = scenariosArray
        self.scenariosAreMultiple = scenariosAreMultiple
        self.winSwitch = winSwitch
        self.difficultyNames = difficultyNames
        self.roundsLeftName = roundsLeftName
        self.additionalSwitchName = additionalSwitchName
        self.additionalSecondSwitchName = additionalSecondSwitchName
        if classesArray == nil, let goodClassesArray = goodClassesArray, let evilClassesArray = evilClassesArray{
            self.classesArray = goodClassesArray + evilClassesArray
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
            if let points = match.playersPoints, points.isEmpty {
                player.addMatch(game: self, match: match, place: match.playersPlaces?[i], points: nil)
            } else {
                player.addMatch(game: self, match: match, place: match.playersPlaces?[i], points: match.playersPoints?[i])
            }
        }
        //If there are points, then append pointsArray and sort it
        if let points = match.playersPoints {
            pointsArray += points
        }
        pointsArray.sort()
        //Calculate total and average time of game
        if let time = match.time {
            totalTime = totalTime + time
            averageTime = {
                var count = 0
                for match in matches {
                    if match.time != nil {
                        count += 1
                        print(count)
                    }
                }
                return totalTime / Double(count)
            }()
        }
        matches.sort()
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
        }
        
        
        //Remove match from matches list
        if let index = matches.index(of: match) {
            matches.remove(at: index)
        }
        
        //Decrease total time and calculate new average
        if let time = match.time {
            totalTime = totalTime - time
            averageTime = {
                var count = 0
                for match in matches {
                    if match.time != nil {
                        count += count
                    }
                }
                return totalTime / Double(count)
            }()
        }
        
        //Calls function removeMatch
        match.removeMatch()
        timesPlayed -= 1
    }
    
    
    
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
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(maxNoOfPlayers, forKey: "maxNoOfPlayers")
        aCoder.encode(thereAreTeams, forKey: "thereAreTeams")
        aCoder.encode(thereArePoints, forKey: "thereArePoints")
        aCoder.encode(type.rawValue, forKey: "type")
        aCoder.encode(timesPlayed, forKey: "timesPlayed")
        aCoder.encode(lastTimePlayed, forKey: "lastTimePlayed")
        aCoder.encode(gameID, forKey: "gameID")
        aCoder.encode(matches, forKey: "matches")
        aCoder.encode(pointsArray, forKey: "pointsArray")
        aCoder.encode(totalTime, forKey: "totalTime")
        aCoder.encode(averageTime, forKey: "averageTime")
        aCoder.encode(icon, forKey: "icon")
        aCoder.encode(pointsExtendedNameArray, forKey: "pointsExtendedNameArray")
        aCoder.encode(classesArray, forKey: "classesArray")
        aCoder.encode(evilClassesArray, forKey: "evilClassesArray")
        aCoder.encode(goodClassesArray, forKey: "goodClassesArray")
        aCoder.encode(expansionsArray, forKey: "expansionsArray")
        aCoder.encode(expansionsAreMultiple, forKey: "expansionsAreMultiple")
        aCoder.encode(scenariosArray, forKey: "scenariosArray")
        aCoder.encode(scenariosAreMultiple, forKey: "scenariosAreMultiple")
        aCoder.encode(winSwitch, forKey: "winSwitch")
        aCoder.encode(difficultyNames, forKey: "difficultyNames")
        aCoder.encode(roundsLeftName, forKey: "roundsLeftName")
        aCoder.encode(additionalSwitchName, forKey: "additionalSwitchName")
        aCoder.encode(dictionary, forKey: "dictionary")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        maxNoOfPlayers = aDecoder.decodeInteger(forKey: "maxNoOfPlayers")
        icon = aDecoder.decodeObject(forKey: "icon") as? UIImage
        thereAreTeams = aDecoder.decodeBool(forKey: "thereAreTeams")
        thereArePoints = aDecoder.decodeBool(forKey: "thereArePoints")
        type = GameType(rawValue: aDecoder.decodeInteger(forKey: "type"))!
        timesPlayed = aDecoder.decodeInteger(forKey: "timesPlayed")
        lastTimePlayed = aDecoder.decodeObject(forKey: "lastTimePlayed") as? Date
        gameID = aDecoder.decodeObject(forKey: "gameID") as! String
        matches = aDecoder.decodeObject(forKey: "matches") as! [Match]
        pointsArray = aDecoder.decodeObject(forKey: "pointsArray") as! [Int]
        totalTime = aDecoder.decodeDouble(forKey: "totalTime")
        averageTime = aDecoder.decodeDouble(forKey: "averageTime")
        pointsExtendedNameArray = aDecoder.decodeObject(forKey: "pointsExtendedNameArray") as? [String]
        classesArray = aDecoder.decodeObject(forKey: "classesArray") as? [String]
        evilClassesArray = aDecoder.decodeObject(forKey: "evilClassesArray") as? [String]
        goodClassesArray = aDecoder.decodeObject(forKey: "goodClassesArray") as? [String]
        expansionsArray = aDecoder.decodeObject(forKey: "expansionsArray") as? [String]
        expansionsAreMultiple = aDecoder.decodeObject(forKey: "expansionsAreMultiple") as? Bool
        scenariosArray = aDecoder.decodeObject(forKey: "scenariosArray") as? [String]
        scenariosAreMultiple = aDecoder.decodeObject(forKey: "scenariosAreMultiple") as? Bool
        winSwitch = aDecoder.decodeObject(forKey: "winSwitch") as? Bool
        difficultyNames = aDecoder.decodeObject(forKey: "difficultyNames") as? [String]
        roundsLeftName = aDecoder.decodeObject(forKey: "roundsLeftName") as? String
        additionalSwitchName = aDecoder.decodeObject(forKey: "additionalSwitchName") as? String
        dictionary = aDecoder.decodeObject(forKey: "dictionary") as? [String: Any]
        super.init()
    }
    
    
}
