//
//  Helper.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 20/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//

import UIKit
import CoreData

class Helper {
    
    
    static func addGame(name: String, type: String, maxNoOfPlayers: Int, pointsExtendedNameArray: [String]?, classesArray: [String]?, goodClassesArray: [String]?, evilClassesArray: [String]?, expansionsArray: [String]?, expansionsAreMultiple: Bool?, scenariosArray: [String]?, scenariosAreMultiple: Bool?, winSwitch: Bool, difficultyNames: [String]?, roundsLeftName: String?, additionalSwitchNames: [String]?) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        
        let game = Game(context: managedContext)
        
        game.name = name
        game.type = type
        game.maxNoOfPlayers = Int32(maxNoOfPlayers)
        if let extendedPointsNames = pointsExtendedNameArray {
            for pointName in extendedPointsNames {
                let extendedPointName = ExtendedPointName(context: managedContext)
                extendedPointName.name = pointName
                extendedPointName.game = game
            }
        }
        
        if let classesArray = classesArray {
            for className in classesArray {
                let gameClass = GameClass(context: managedContext)
                gameClass.name = className
                gameClass.game = game
                if let goodClassesArray = goodClassesArray, let evilClassesArray = evilClassesArray {
                    if goodClassesArray.contains(className) {
                        gameClass.type = ClassType.Good
                    } else if evilClassesArray.contains(className) {
                        gameClass.type = ClassType.Evil
                    }
                }
            }
        }
        
        if let expansionsArray = expansionsArray {
            game.expansionsAreMultiple = expansionsAreMultiple!
            for expansionName in expansionsArray {
                let expansion = Expansion(context: managedContext)
                expansion.name = expansionName
                expansion.game = game
            }
        }
        
        if let scenariosArray = scenariosArray {
            game.scenariosAreMultiple = scenariosAreMultiple!
            for scenarioName in scenariosArray {
                let scenario = Scenario(context: managedContext)
                scenario.name = scenarioName
                scenario.game = game
            }
        }
        
        if let difficultyNames = difficultyNames {
            for difficultyName in difficultyNames {
                let difficulty = Difficulty(context: managedContext)
                difficulty.name = difficultyName
                difficulty.game = game
            }
        }
        
        game.roundsLeftName = roundsLeftName
        game.winSwitch = winSwitch
        
        if let additionalSwitchNames = additionalSwitchNames {
            for additionalSwitchName in additionalSwitchNames {
                let additionalBool = AdditionalBool(context: managedContext)
                game.addToAdditionalBools(additionalBool)
                additionalBool.name = additionalSwitchName
            }
        }
        
        print(game)
    }
    
    static func addMatch(game: Game, players: [Player], points: [Int]?, places: [Int], dictionary: [String: Any]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let match = Match(context: managedContext)
        match.game = game
        
        let playersClasses = dictionary["Classes"] as? [Player: GameClass]
        for (i, player) in players.enumerated() {
            let playerResult = PlayerResult(context: managedContext)
            playerResult.player = player
            playerResult.match = match
            playerResult.place = Int32(places[i])
            if let point = points?[i] {
                playerResult.point = Int32(point)
            }
            playerResult.gameClass = playersClasses?[player]
            if let pointsExtendedDict = dictionary["Points"] as? [Player: Any], let pointsExtendedPlayer = pointsExtendedDict[player] as? [String: Int] {
                for (sectionName, point) in pointsExtendedPlayer {
                    let extendedPoint = ExtendedPoint(context: managedContext)
                    extendedPoint.name = sectionName
                    extendedPoint.point = Int32(point)
                    extendedPoint.result = playerResult
                }
            }
        }
        
        if let scenarioArray = dictionary["Scenarios"] as? [Scenario] {
            match.addToScenarios(NSSet(array: scenarioArray))
        }
        
        if let expansionArray = dictionary["Expansions"] as? [Expansion] {
            match.addToExpansions(NSSet(array: expansionArray))
        }
        
        if let difficulty = dictionary["Difficulty"] as? Difficulty {
            match.difficulty = difficulty
        }
        
        
        
        
    }
}

