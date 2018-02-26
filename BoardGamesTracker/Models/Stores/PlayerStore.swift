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

    let playersArchiveURL: URL = {
        let directories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var directory = directories.first!
        return directory.appendingPathComponent("players.archive")
    }()
    
    init() {
        if let archivedPlayers = NSKeyedUnarchiver.unarchiveObject(withFile: playersArchiveURL.path) as? [Player] {
            allPlayers = archivedPlayers
        }
        allPlayers.sort()
    }
    
    
    func save() -> Bool {
        print("Saving games to \(playersArchiveURL.path)")
        var playersWithoutGames = [Player]()
        for player in allPlayers {
            if player.timesPlayed == 0 {
                playersWithoutGames.append(player)
            }
        }
        return NSKeyedArchiver.archiveRootObject(playersWithoutGames, toFile: playersArchiveURL.path)
    }
    
    //MARK: - Functions
    func addPlayer(_ player: Player) {
        allPlayers.append(player)
        allPlayers.sort()
    }

    @discardableResult func removePlayer(_ player: Player) -> Player {
        if let index = allPlayers.index(of: player) {
            allPlayers.remove(at: index)
        }
        return player
    }
    
}
