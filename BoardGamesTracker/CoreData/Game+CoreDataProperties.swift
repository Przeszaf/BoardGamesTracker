//
//  Game+CoreDataProperties.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 27/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var expansionsAreMultiple: Bool
    @NSManaged public var lastTimePlayed: NSDate?
    @NSManaged public var maxNoOfPlayers: Int32
    @NSManaged public var name: String?
    @NSManaged public var roundsLeftName: String?
    @NSManaged public var scenariosAreMultiple: Bool
    @NSManaged public var type: String?
    @NSManaged public var winSwitch: Bool
    @NSManaged public var inCollection: Bool
    @NSManaged public var additionalBools: NSSet?
    @NSManaged public var classes: NSSet?
    @NSManaged public var difficulties: NSSet?
    @NSManaged public var expansions: NSSet?
    @NSManaged public var extendedPointNames: NSSet?
    @NSManaged public var matches: NSSet?
    @NSManaged public var players: NSSet?
    @NSManaged public var scenarios: NSSet?

}

// MARK: Generated accessors for additionalBools
extension Game {

    @objc(addAdditionalBoolsObject:)
    @NSManaged public func addToAdditionalBools(_ value: AdditionalBool)

    @objc(removeAdditionalBoolsObject:)
    @NSManaged public func removeFromAdditionalBools(_ value: AdditionalBool)

    @objc(addAdditionalBools:)
    @NSManaged public func addToAdditionalBools(_ values: NSSet)

    @objc(removeAdditionalBools:)
    @NSManaged public func removeFromAdditionalBools(_ values: NSSet)

}

// MARK: Generated accessors for classes
extension Game {

    @objc(addClassesObject:)
    @NSManaged public func addToClasses(_ value: GameClass)

    @objc(removeClassesObject:)
    @NSManaged public func removeFromClasses(_ value: GameClass)

    @objc(addClasses:)
    @NSManaged public func addToClasses(_ values: NSSet)

    @objc(removeClasses:)
    @NSManaged public func removeFromClasses(_ values: NSSet)

}

// MARK: Generated accessors for difficulties
extension Game {

    @objc(addDifficultiesObject:)
    @NSManaged public func addToDifficulties(_ value: Difficulty)

    @objc(removeDifficultiesObject:)
    @NSManaged public func removeFromDifficulties(_ value: Difficulty)

    @objc(addDifficulties:)
    @NSManaged public func addToDifficulties(_ values: NSSet)

    @objc(removeDifficulties:)
    @NSManaged public func removeFromDifficulties(_ values: NSSet)

}

// MARK: Generated accessors for expansions
extension Game {

    @objc(addExpansionsObject:)
    @NSManaged public func addToExpansions(_ value: Expansion)

    @objc(removeExpansionsObject:)
    @NSManaged public func removeFromExpansions(_ value: Expansion)

    @objc(addExpansions:)
    @NSManaged public func addToExpansions(_ values: NSSet)

    @objc(removeExpansions:)
    @NSManaged public func removeFromExpansions(_ values: NSSet)

}

// MARK: Generated accessors for extendedPointNames
extension Game {

    @objc(addExtendedPointNamesObject:)
    @NSManaged public func addToExtendedPointNames(_ value: ExtendedPointName)

    @objc(removeExtendedPointNamesObject:)
    @NSManaged public func removeFromExtendedPointNames(_ value: ExtendedPointName)

    @objc(addExtendedPointNames:)
    @NSManaged public func addToExtendedPointNames(_ values: NSSet)

    @objc(removeExtendedPointNames:)
    @NSManaged public func removeFromExtendedPointNames(_ values: NSSet)

}

// MARK: Generated accessors for matches
extension Game {

    @objc(addMatchesObject:)
    @NSManaged public func addToMatches(_ value: Match)

    @objc(removeMatchesObject:)
    @NSManaged public func removeFromMatches(_ value: Match)

    @objc(addMatches:)
    @NSManaged public func addToMatches(_ values: NSSet)

    @objc(removeMatches:)
    @NSManaged public func removeFromMatches(_ values: NSSet)

}

// MARK: Generated accessors for players
extension Game {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Player)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Player)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}

// MARK: Generated accessors for scenarios
extension Game {

    @objc(addScenariosObject:)
    @NSManaged public func addToScenarios(_ value: Scenario)

    @objc(removeScenariosObject:)
    @NSManaged public func removeFromScenarios(_ value: Scenario)

    @objc(addScenarios:)
    @NSManaged public func addToScenarios(_ values: NSSet)

    @objc(removeScenarios:)
    @NSManaged public func removeFromScenarios(_ values: NSSet)

}
