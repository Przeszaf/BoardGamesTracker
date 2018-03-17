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
    var premadeGames = [Game]()
    
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
        
        //FIXME: Add all premade games
        //Check if premadeGames were already added to allGames, if so then remove from premadeGames
        premadeGames.append(Game(name: "Avalon", type: .TeamWithPlaces, maxNoOfPlayers: 10, pointsExtendedNameArray: nil, classesArray: nil, goodClassesArray: ["Loyal servant of Arthur", "Merlin", "Percival"], evilClassesArray: ["Minion of Mordred", "Assassin", "Oberon", "Morgana"], expansionsArray: ["Lady of the Lake", "Excalibur"], expansionsAreMultiple: true, scenariosArray: nil, scenariosAreMultiple: nil, winSwitch: true, difficultyNames: nil, roundsLeftName: nil, additionalSwitchName: "Merlin killed", additionalSecondSwitchName: nil))
        premadeGames.append(Game(name: "Dixit", type: .SoloWithPoints, maxNoOfPlayers: 12))
        premadeGames.append(Game(name: "Robinson Crusoe", type: .Cooperation, maxNoOfPlayers: 4, pointsExtendedNameArray: nil, classesArray: ["Ranger", "Warrior", "Cook", "Builder"], goodClassesArray: nil, evilClassesArray: nil, expansionsArray: nil, expansionsAreMultiple: nil, scenariosArray: ["Scenario 1", "Scenario 2", "Scenario 3"], scenariosAreMultiple: false, winSwitch: true, difficultyNames: nil, roundsLeftName: "Days", additionalSwitchName: "Playing with Friday", additionalSecondSwitchName: "Playing with Dog"))
        premadeGames.append(Game(name: "Wanna bet?", type: .SoloWithPlaces, maxNoOfPlayers: 10))
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
