//
//  Match+CoreDataProperties.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 21/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//
//

import Foundation
import CoreData


extension Match {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Match> {
        return NSFetchRequest<Match>(entityName: "Match")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var time: Double
    @NSManaged public var roundsLeft: Int32
    @NSManaged public var difficulty: Difficulty?
    @NSManaged public var scenarios: NSSet?
    @NSManaged public var game: Game?
    @NSManaged public var players: NSSet?
    @NSManaged public var results: PlayerResult?
    @NSManaged public var expansions: NSSet?
    @NSManaged public var additionalBool: AdditionalBool?

}

// MARK: Generated accessors for scenarios
extension Match {

    @objc(addScenariosObject:)
    @NSManaged public func addToScenarios(_ value: Scenario)

    @objc(removeScenariosObject:)
    @NSManaged public func removeFromScenarios(_ value: Scenario)

    @objc(addScenarios:)
    @NSManaged public func addToScenarios(_ values: NSSet)

    @objc(removeScenarios:)
    @NSManaged public func removeFromScenarios(_ values: NSSet)

}

// MARK: Generated accessors for players
extension Match {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Player)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Player)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}

// MARK: Generated accessors for expansions
extension Match {

    @objc(addExpansionsObject:)
    @NSManaged public func addToExpansions(_ value: Expansion)

    @objc(removeExpansionsObject:)
    @NSManaged public func removeFromExpansions(_ value: Expansion)

    @objc(addExpansions:)
    @NSManaged public func addToExpansions(_ values: NSSet)

    @objc(removeExpansions:)
    @NSManaged public func removeFromExpansions(_ values: NSSet)

}
