//
//  PlayerStore.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 18/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class PlayerStore {
    
    //MARK: - Variables
    var allPlayers = [Player]()

    //MARK: - Functions
    func addPlayer(_ player: Player) {
        allPlayers.append(player)
    }

    @discardableResult func removePlayer(_ player: Player) -> Player {
        if let index = allPlayers.index(of: player) {
            allPlayers.remove(at: index)
        }
        return player
    }
}
