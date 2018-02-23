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
    var dictionary: [Player: Any]?
    
    init(game: Game, players: [Player], playersPoints: [Int]?, playersPlaces: [Int]?, date: Date, time: TimeInterval, location: CLLocation?, bool: Bool?, intArray: [Int]?, intIntArray: [[Int]]?, dictionary: [Player: Any]?) {
        super.init(game: game, players: players, playersPoints: playersPoints, playersPlaces: playersPlaces, date: date, time: time, location: location)
        self.bool = bool
        self.intArray = intArray
        self.intIntArray = intIntArray
        self.dictionary = dictionary
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(bool, forKey: "bool")
        aCoder.encode(intArray, forKey: "intArray")
        aCoder.encode(intIntArray, forKey: "intIntArray")
        aCoder.encode(dictionary, forKey: "dictionary")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bool = aDecoder.decodeObject(forKey: "bool") as? Bool
        intArray = aDecoder.decodeObject(forKey: "intArray") as? [Int]
        intIntArray = aDecoder.decodeObject(forKey: "intIntArray") as? [[Int]]
        dictionary = aDecoder.decodeObject(forKey: "dictionary") as? [Player: Any]
    }
    
}
