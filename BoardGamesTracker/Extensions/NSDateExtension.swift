//
//  NSDateExtension.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 20/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

extension NSDate {
    
    //Used to get string from Date
    func toString() -> String {
        let date = self as Date
        return date.toString()
    }
    
    func toStringWithHour() -> String {
        let date = self as Date
        return date.toStringWithHour()
    }
}
