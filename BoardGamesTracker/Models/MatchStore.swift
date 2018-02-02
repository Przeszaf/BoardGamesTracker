//
//  MatchStore.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 18/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class MatchStore {
    
    //MARK: - Variables
    var allMatches = [Match]()

    //MARK: - Functions
    func addMatch(_ match: Match) {
        allMatches.append(match)
        match.game!.addMatch(match: match)
        
        let game = match.game
        let players = match.players
        let places = match.playersPlaces
        let points = match.playersPoints
        for (i, player) in players.enumerated() {
            player.addMatch(game: game!, match: match, place: places?[i], points: points?[i])
        }
        //Add Player-Related attributes
        
    }

    @discardableResult func removeMatch(_ match: Match) -> Match {
        if let index = allMatches.index(of: match) {
            allMatches.remove(at: index)
        }
        return match
    }
    
    
}
