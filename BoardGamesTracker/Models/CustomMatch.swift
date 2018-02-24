//
//  CustomMatch.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreLocation

class CustomMatch: Match {
    
    
    //Generic variables used to hold information for custom matches - they mean different thins for different games - Look up in documentation
    var bool: Bool?
    var intArray: [Int]?
    var intIntArray: [[Int]]?
    var playersClasses: [String: Any]?
    
    init(game: Game, players: [Player], playersPoints: [Int]?, playersPlaces: [Int]?, date: Date, time: TimeInterval, location: CLLocation?, bool: Bool?, intArray: [Int]?, intIntArray: [[Int]]?, playersClasses: [String: Any]?) {
        super.init(game: game, players: players, playersPoints: playersPoints, playersPlaces: playersPlaces, date: date, time: time, location: location)
        self.bool = bool
        self.intArray = intArray
        self.intIntArray = intIntArray
        self.playersClasses = playersClasses
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(bool, forKey: "bool")
        aCoder.encode(intArray, forKey: "intArray")
        aCoder.encode(intIntArray, forKey: "intIntArray")
        
        
        if let game = game, game.name == "Avalon" {
            var codablePlayersClasses = [String: String]()
            if let avalonClasses = playersClasses as? [String: AvalonClasses] {
                for (playerID, avalonClass) in avalonClasses {
                    codablePlayersClasses[playerID] = avalonClass.rawValue
                }
            }
            aCoder.encode(codablePlayersClasses, forKey: "codablePlayersClasses")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bool = aDecoder.decodeObject(forKey: "bool") as? Bool
        intArray = aDecoder.decodeObject(forKey: "intArray") as? [Int]
        intIntArray = aDecoder.decodeObject(forKey: "intIntArray") as? [[Int]]
        let codablePlayersClasses = aDecoder.decodeObject(forKey: "codablePlayersClasses") as! [String: String]
        if let game = game, game.name == "Avalon" {
            playersClasses = [String: Any]()
            for (playerID, avalonClassRaw) in codablePlayersClasses {
                playersClasses![playerID] = AvalonClasses(rawValue: avalonClassRaw)
            }
        }
    }
    
}
