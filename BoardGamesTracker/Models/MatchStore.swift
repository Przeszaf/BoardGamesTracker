//
//  MatchStore.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 18/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

//MARK: - Variables
var allMatches = [Match]()

//MARK: - Functions
func addMatch(_ match: Match) {
    allMatches.append(match)
}

@discardableResult func removeMatch(_ match: Match) -> Match {
    if let index = allMatches.index(of: match) {
        allMatches.remove(at: index)
    }
    return match
}
