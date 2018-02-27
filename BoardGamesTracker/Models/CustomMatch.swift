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
    var playersClasses: [String: Any]?
    
    init(game: Game, players: [Player], playersPoints: [Int]?, playersPlaces: [Int]?, date: Date, time: TimeInterval, location: CLLocation?, dictionary: [String: Any]?, playersClasses: [String: Any]?) {
        super.init(game: game, players: players, playersPoints: playersPoints, playersPlaces: playersPlaces, date: date, time: time, location: location)
        self.dictionary = dictionary
        self.playersClasses = playersClasses
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(dictionary, forKey: "dictionary")
        
        
        if let game = game {
            var codablePlayersClasses = [String: String]()
            if game.name == "Avalon" {
                if let avalonClasses = playersClasses as? [String: AvalonClasses] {
                    for (playerID, avalonClass) in avalonClasses {
                        codablePlayersClasses[playerID] = avalonClass.rawValue
                    }
                }
            } else if game.name == "Pandemic" {
                if let pandemicClasses = playersClasses as? [String: PandemicClasses] {
                    for (playerID, pandemicClass) in pandemicClasses {
                        codablePlayersClasses[playerID] = pandemicClass.rawValue
                    }
                }
            }
            aCoder.encode(codablePlayersClasses, forKey: "codablePlayersClasses")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dictionary = aDecoder.decodeObject(forKey: "dictionary") as? [String: Any]
        
        if let codablePlayersClasses = aDecoder.decodeObject(forKey: "codablePlayersClasses") as? [String: String] {
            if let game = game {
                if game.name == "Avalon" {
                    playersClasses = [String: Any]()
                    for (playerID, avalonClassRaw) in codablePlayersClasses {
                        playersClasses![playerID] = AvalonClasses(rawValue: avalonClassRaw)
                    }
                } else if game.name == "Pandemic" {
                    playersClasses = [String: Any]()
                    for (playerID, pandemicClassRaw) in codablePlayersClasses {
                        playersClasses![playerID] = PandemicClasses(rawValue: pandemicClassRaw)
                    }
                }
            }
        }
    }
}
