//
//  GameClass+CoreDataProperties.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 21/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//
//

import Foundation
import CoreData


extension GameClass {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GameClass> {
        return NSFetchRequest<GameClass>(entityName: "GameClass")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var game: Game?
    @NSManaged public var results: NSSet?

}

// MARK: Generated accessors for results
extension GameClass {

    @objc(addResultsObject:)
    @NSManaged public func addToResults(_ value: PlayerResult)

    @objc(removeResultsObject:)
    @NSManaged public func removeFromResults(_ value: PlayerResult)

    @objc(addResults:)
    @NSManaged public func addToResults(_ values: NSSet)

    @objc(removeResults:)
    @NSManaged public func removeFromResults(_ values: NSSet)

}
