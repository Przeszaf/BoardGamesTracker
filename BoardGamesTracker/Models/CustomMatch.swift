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
    var dictionary: [String: Any]?
    var playersClasses: [String: String]?
    
    init(game: Game, players: [Player], playersPoints: [Int]?, playersPlaces: [Int]?, date: Date, time: TimeInterval?, location: CLLocation?, dictionary: [String: Any], playersClasses: [Player: String]?) {
        super.init(game: game, players: players, playersPoints: playersPoints, playersPlaces: playersPlaces, date: date, time: time, location: location)
        self.dictionary = toCodable(dictionary: dictionary)
        self.playersClasses = toCodable(playersClasses: playersClasses)
    }
    
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(dictionary, forKey: "dictionary")
        aCoder.encode(playersClasses, forKey: "playersClasses")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dictionary = aDecoder.decodeObject(forKey: "dictionary") as? [String: Any]
        playersClasses = aDecoder.decodeObject(forKey: "playersClasses") as? [String: String]
    }
    
    
    //Turns [Player: Any] into [String: Any] by using playerID instead of direct reference to Player as key
    private func toCodable(dictionary: [String: Any]) -> [String: Any]? {
        if game?.name == "7 Wonders" {
            if let pointsDict = dictionary["Points"] as? [Player: [Int]] {
                var pointsDictCodable = [String: [Int]]()
                for (player, pointsArray) in pointsDict {
                    pointsDictCodable[player.playerID] = pointsArray
                }
                var dictionaryCodable = dictionary
                dictionaryCodable["Points"] = pointsDictCodable
                return dictionaryCodable
            }
        }
        return dictionary
    }
    
    private func toCodable(playersClasses: [Player: String]?) -> [String: String]? {
        guard let playersClasses = playersClasses else { return nil }
        var playersClassesCodable = [String: String]()
        for (player, profession) in playersClasses {
            playersClassesCodable[player.playerID] = profession
        }
        return playersClassesCodable
    }
}
