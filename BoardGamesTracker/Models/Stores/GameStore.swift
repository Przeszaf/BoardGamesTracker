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
        let game = Game(name: "Avalon", type: .TeamWithPlaces, maxNoOfPlayers: 10, pointsExtendedNameArray: nil, classesArray: ["Good", "Good", "Good", "Bad", "Bad", "Bad", "Bad"], goodClassesArray: ["Good", "Good", "Good"], evilClassesArray: ["Bad", "Bad", "Bad", "Bad"], expansionsArray: nil, expansionsAreMultiple: nil, scenariosArray: nil, scenariosAreMultiple: nil, winSwitch: nil, difficultyNames: nil, roundsLeftName: "Days", additionalSwitchName: nil, additionalSecondSwitchName: nil)
        allGames.append(game)
        
        let fullPointsGame = Game(name: "All options points", type: .SoloWithPoints, maxNoOfPlayers: 10, pointsExtendedNameArray: ["War", "Leaders", "Knowledge", "Hihihi", "Others"], classesArray: ["Class coop1", "Class coop2", "Class coop3", "Class coop4"], goodClassesArray: nil, evilClassesArray: nil, expansionsArray: ["Expansion 1 coop", "Expansion 2 coop"], expansionsAreMultiple: true, scenariosArray: ["Scenario 1", "Scenario 2", "Scenario 3", "Scenario 4", ], scenariosAreMultiple: false, winSwitch: true, difficultyNames: ["Easy", "Medium", "Hard"], roundsLeftName: "Days", additionalSwitchName: "Playing with Dog", additionalSecondSwitchName: "Playing with Friday")
        allGames.append(fullPointsGame)

        //Check if premadeGames were already added to allGames, if so then remove from premadeGames
        
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
