//
//  Match.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class Match: NSObject, Comparable, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(game, forKey: "game")
        aCoder.encode(players, forKey: "players")
        aCoder.encode(playersPoints, forKey: "playersPoints")
        aCoder.encode(playersPlaces, forKey: "playersPlaces")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(matchID, forKey: "matchID")
    }
    
    required init?(coder aDecoder: NSCoder) {
        game = aDecoder.decodeObject(forKey: "game") as? Game
        players = aDecoder.decodeObject(forKey: "players") as! [Player]
        playersPoints = aDecoder.decodeObject(forKey: "playersPoints") as? [Int]
        playersPlaces = aDecoder.decodeObject(forKey: "playersPlaces") as? [Int]
        date = aDecoder.decodeObject(forKey: "date") as! Date
        time = aDecoder.decodeDouble(forKey: "time")
        matchID = aDecoder.decodeObject(forKey: "matchID") as! String
        super.init()
    }
    
    
    //MARK: - Match attributes
    var game: Game?
    var players: [Player]
    var playersPoints: [Int]?
    var playersPlaces: [Int]?
    var date: Date
    var time: TimeInterval
    
    let matchID: String
    
    //MARK: - Initializers
    
    init(game: Game, players: [Player], playersPoints: [Int]?, playersPlaces: [Int]?, date: Date, time: TimeInterval) {
        self.game = game
        self.players = players
        self.playersPoints = playersPoints
        self.playersPlaces = playersPlaces
        self.date = date
        print(date.toStringWithHour())
        self.time = time
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
    
    func removeMatch() {
        for player in players {
            player.removeMatch(match: self)
        }
        players.removeAll()
        game = nil
    }

    
}
