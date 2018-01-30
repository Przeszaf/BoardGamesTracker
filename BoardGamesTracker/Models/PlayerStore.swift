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
    
    func sort() {
        allPlayers.sort { (player1, player2) -> Bool in
            if let date1 = player1.lastTimePlayed, let date2 = player2.lastTimePlayed {
                if date1 < date2 {
                    if player1.name < player2.name {
                        return true
                    }
                }
            }
            if player1.name < player2.name {
                return true
            }
            return false
        }
    }
}
