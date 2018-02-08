//
//  ExtensionTimeInterval.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 08/02/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

extension TimeInterval {
    
    //Used to get string from time interval
    func toString() -> String {
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time/60) % 60
        let hours = time/3600
        if seconds == 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(hours)h \(minutes)m \(seconds)s"
    }
}
