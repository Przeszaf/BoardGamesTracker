//
//  BoardGameStore.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 09/01/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit

class GameStore {
    
    //MARK: - Variables
    var allGames = [Game]()
    var playerStore: PlayerStore!
    var customGames = [CustomGame]()
    
    let gamesArchiveURL: URL = {
        let directories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var directory = directories.first!
        return directory.appendingPathComponent("games.archive")
    }()
    
    init() {
        print(gamesArchiveURL.path)
        if let archivedGames = NSKeyedUnarchiver.unarchiveObject(withFile: gamesArchiveURL.path) as? [Game] {
            allGames = archivedGames
        }
        
        //Add all custom games
        customGames.append(CustomGame(name: "Avalon", type: .TeamWithPlaces, maxNoOfPlayers: 10, icon: UIImage(named: "Avalon")))
        customGames.append(CustomGame(name: "Pandemic", type: .Cooperation, maxNoOfPlayers: 4, icon: UIImage(named: "Avalon")))
        customGames.append(CustomGame(name: "Carcassonne", type: .SoloWithPoints, maxNoOfPlayers: 5, icon: UIImage(named: "Avalon")))
        customGames.append(CustomGame(name: "Codenames", type: .TeamWithPlaces, maxNoOfPlayers: 10, icon: UIImage(named: "Codenames")))
        customGames.append(CustomGame(name: "7 Wonders", type: .SoloWithPoints, maxNoOfPlayers: 8, icon: UIImage(named: "7 Wonders")))
        customGames.append(CustomGame(name: "Robinson Crusoe", type: .Cooperation, maxNoOfPlayers: 4, icon: UIImage(named: "Robinson Crusoe")))
        customGames.append(CustomGame(name: "Time's up", type: .TeamWithPlaces, maxNoOfPlayers: 10, icon: UIImage(named: "Time's up")))
        customGames.append(CustomGame(name: "Dixit", type: .SoloWithPoints, maxNoOfPlayers: 10, icon: UIImage(named: "Dixit")))
        customGames.append(CustomGame(name: "Mascarade", type: .SoloWithPlaces, maxNoOfPlayers: 10, icon: UIImage(named: "Mascarade")))
        customGames.append(CustomGame(name: "5 Second Rule", type: .SoloWithPoints, maxNoOfPlayers: 10, icon: UIImage(named: "5 Second Rule")))
        //Check if customGames were already added to allGames, if so then remove from customGames
        for game in allGames {
            if let customGame = game as? CustomGame {
                let index = customGames.index(where: {$0.name == customGame.name})
                customGames.remove(at: index!)
            }
        }
        
    }

    //MARK: - Functions
    func addGame(_ game: Game) {
        allGames.append(game)
        allGames.sort()
    }
    
    @discardableResult func removeGame(_ game: Game) -> Game {
        if let index = allGames.index(of: game) {
            game.removeGame()
            allGames.remove(at: index)
            allGames.sort()
        }
        return game
    }
    
    func save() -> Bool {
        print("Saving games to \(gamesArchiveURL.path)")
        return NSKeyedArchiver.archiveRootObject(allGames, toFile: gamesArchiveURL.path)
    }
    
    func setPlayerStore() {
        for game in allGames {
            for match in game.matches {
                for (i, player) in match.players.enumerated() {
                    if player.gamesPlayed.index(of: game) == nil {
                        player.gamesPlayed.append(game)
                        player.matchesPlayed[game] = [match]
                        player.gamesPlace[game] = [match.playersPlaces![i]]
                        if game.type == .SoloWithPoints {
                            player.gamesPoints[game] = [match.playersPoints![i]]
                        }
                    } else {
                        player.matchesPlayed[game]?.append(match)
                        player.gamesPlace[game]?.append(match.playersPlaces![i])
                        if game.type == .SoloWithPoints {
                            player.gamesPoints[game]?.append(match.playersPoints![i])
                        }
                    }
                    player.matchesPlayed[game]?.sort()
                    if playerStore.allPlayers.index(of: player) == nil {
                        playerStore.allPlayers.append(player)
                    }
                }
            }
        }
        playerStore.allPlayers.sort()
    }

}
