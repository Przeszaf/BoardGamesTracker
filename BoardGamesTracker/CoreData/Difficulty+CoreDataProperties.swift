//
//  Difficulty+CoreDataProperties.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 04/04/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//
//

import Foundation
import CoreData


extension Difficulty {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Difficulty> {
        return NSFetchRequest<Difficulty>(entityName: "Difficulty")
    }

    @NSManaged public var name: String?
    @NSManaged public var game: Game?
    @NSManaged public var matches: NSSet?

}

// MARK: Generated accessors for matches
extension Difficulty {

    @objc(addMatchesObject:)
    @NSManaged public func addToMatches(_ value: Match)

    @objc(removeMatchesObject:)
    @NSManaged public func removeFromMatches(_ value: Match)

    @objc(addMatches:)
    @NSManaged public func addToMatches(_ values: NSSet)

    @objc(removeMatches:)
    @NSManaged public func removeFromMatches(_ values: NSSet)

}
