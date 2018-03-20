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
    
    
    static func addGame(name: String, type: String, maxNoOfPlayers: Int, pointsExtendedNameArray: [String]?, classesArray: [String]?, goodClassesArray: [String]?, evilClassesArray: [String]?, expansionsArray: [String]?, expansionsAreMultiple: Bool?, scenariosArray: [String]?, scenariosAreMultiple: Bool?, winSwitch: Bool, difficultyNames: [String]?, roundsLeftName: String?, additionalSwitchName: String?, additionalSecondSwitchName: String?) {
        
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
        
        game.additionalSwitchName = additionalSwitchName
        game.additionalSecondSwitchName = additionalSecondSwitchName
        
        print(game)
    }
}

