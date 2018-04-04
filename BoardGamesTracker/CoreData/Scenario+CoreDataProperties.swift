//
//  Scenario+CoreDataProperties.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 27/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//
//

import Foundation
import CoreData


extension Scenario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scenario> {
        return NSFetchRequest<Scenario>(entityName: "Scenario")
    }

    @NSManaged public var name: String?
    @NSManaged public var game: Game?
    @NSManaged public var matches: NSSet?

}

// MARK: Generated accessors for matches
extension Scenario {

    @objc(addMatchesObject:)
    @NSManaged public func addToMatches(_ value: Match)

    @objc(removeMatchesObject:)
    @NSManaged public func removeFromMatches(_ value: Match)

    @objc(addMatches:)
    @NSManaged public func addToMatches(_ values: NSSet)

    @objc(removeMatches:)
    @NSManaged public func removeFromMatches(_ values: NSSet)

}
