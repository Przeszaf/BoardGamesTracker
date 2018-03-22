//
//  Player+CoreDataProperties.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var lastTimePlayed: NSDate?
    @NSManaged public var name: String?
    @NSManaged public var games: NSSet?
    @NSManaged public var matches: NSSet?
    @NSManaged public var results: NSSet?

}

// MARK: Generated accessors for games
extension Player {

    @objc(addGamesObject:)
    @NSManaged public func addToGames(_ value: Game)

    @objc(removeGamesObject:)
    @NSManaged public func removeFromGames(_ value: Game)

    @objc(addGames:)
    @NSManaged public func addToGames(_ values: NSSet)

    @objc(removeGames:)
    @NSManaged public func removeFromGames(_ values: NSSet)

}

// MARK: Generated accessors for matches
extension Player {

    @objc(addMatchesObject:)
    @NSManaged public func addToMatches(_ value: Match)

    @objc(removeMatchesObject:)
    @NSManaged public func removeFromMatches(_ value: Match)

    @objc(addMatches:)
    @NSManaged public func addToMatches(_ values: NSSet)

    @objc(removeMatches:)
    @NSManaged public func removeFromMatches(_ values: NSSet)

}

// MARK: Generated accessors for results
extension Player {

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: PlayerResult)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: PlayerResult)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)

}
