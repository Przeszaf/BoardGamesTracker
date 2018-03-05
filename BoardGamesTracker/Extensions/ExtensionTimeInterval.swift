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
    func toStringWithSeconds() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        formatter.unitsStyle = .positional
        return formatter.string(from: self)!
    }
    
    func toString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.zeroFormattingBehavior = .default
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: self)!
    }
    
    func toStringWithDays() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.zeroFormattingBehavior = .default
        formatter.unitsStyle = .full
        return formatter.string(from: self)!
    }
}
