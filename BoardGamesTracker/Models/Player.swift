//
//  Player.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class Player {
    var name: String
    var birthDate: Date?
    var lastTimePlayed: Date?
    var timesPlayed: Int
    
    init(name: String, birthDate: Date?) {
        self.name = name
        self.birthDate = birthDate
        lastTimePlayed = nil
        timesPlayed = 0
    }
}
