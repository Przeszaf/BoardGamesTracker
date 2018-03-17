//
//  Match.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreLocation

class Match: NSObject, Comparable, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(game, forKey: "game")
        aCoder.encode(players, forKey: "players")
        aCoder.encode(playersPoints, forKey: "playersPoints")
        aCoder.encode(playersPlaces, forKey: "playersPlaces")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(matchID, forKey: "matchID")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(imageKey, forKey: "imageKey")
        aCoder.encode(dictionary, forKey: "dictionary")
    }
    
    required init?(coder aDecoder: NSCoder) {
        game = aDecoder.decodeObject(forKey: "game") as? Game
        players = aDecoder.decodeObject(forKey: "players") as! [Player]
        playersPoints = aDecoder.decodeObject(forKey: "playersPoints") as? [Int]
        playersPlaces = aDecoder.decodeObject(forKey: "playersPlaces") as? [Int]
        date = aDecoder.decodeObject(forKey: "date") as! Date
        time = aDecoder.decodeObject(forKey: "time") as? Double
        matchID = aDecoder.decodeObject(forKey: "matchID") as! String
        location = aDecoder.decodeObject(forKey: "location") as? CLLocation
        imageKey = aDecoder.decodeObject(forKey: "imageKey") as! String
        dictionary = aDecoder.decodeObject(forKey: "dictionary") as! [String: Any]
        super.init()
    }
    
    //MARK: - Match attributes
    var game: Game?
    var players: [Player]
    var playersPoints: [Int]?
    var playersPlaces: [Int]?
    var date: Date
    var time: TimeInterval?
    var location: CLLocation?
    let imageKey: String
    var dictionary = [String: Any]()
    
    let matchID: String
    
    //MARK: - Initializers
    
    init(game: Game, players: [Player], playersPoints: [Int]?, playersPlaces: [Int]?, dictionary: [String: Any]?, date: Date, time: TimeInterval?, location: CLLocation?) {
        self.game = game
        self.players = players
        self.playersPoints = playersPoints
        self.playersPlaces = playersPlaces
        self.date = date
        self.time = time
        self.location = location
        matchID = NSUUID().uuidString
        imageKey = UUID().uuidString
        super.init()
        if let dictionary = dictionary {
            self.dictionary = toCodable(dictionary: dictionary)
        }
        if let points = playersPoints, points.isEmpty {
            self.playersPoints = nil
        }
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
    
    func removeMatch() {
        for player in players {
            player.removeMatch(match: self)
        }
        players.removeAll()
        game = nil
    }
    
    
    //Turns [Player: Any] into [String: Any] by using playerID instead of direct reference to Player as key
    private func toCodable(dictionary: [String: Any]) -> [String: Any] {
        var dictionaryCodable = dictionary
        
        if game?.pointsExtendedNameArray != nil {
            if let pointsDict = dictionary["Points"] as? [Player: [Int]] {
                var pointsDictCodable = [String: [Int]]()
                for (player, pointsArray) in pointsDict {
                    pointsDictCodable[player.playerID] = pointsArray
                }
                dictionaryCodable["Points"] = pointsDictCodable
            }
        }
        
        if game?.classesArray != nil {
            if let classesDictionary = dictionary["Classes"] as? [Player: String] {
                var classDictCodable = [String: String]()
                for (player, playerClass) in classesDictionary {
                    classDictCodable[player.playerID] = playerClass
                }
                dictionaryCodable["Classes"] = classDictCodable
            }
        }
        
        return dictionaryCodable
    }

    
}
