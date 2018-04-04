//
//  PlayerResult+CoreDataProperties.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 04/04/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//
//

import Foundation
import CoreData


extension PlayerResult {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerResult> {
        return NSFetchRequest<PlayerResult>(entityName: "PlayerResult")
    }

    @NSManaged public var place: Int32
    @NSManaged public var point: Int32
    @NSManaged public var extendedPoint: NSSet?
    @NSManaged public var gameClass: GameClass?
    @NSManaged public var match: Match?
    @NSManaged public var player: Player?

}

// MARK: Generated accessors for extendedPoint
extension PlayerResult {

    @objc(addExtendedPointObject:)
    @NSManaged public func addToExtendedPoint(_ value: ExtendedPoint)

    @objc(removeExtendedPointObject:)
    @NSManaged public func removeFromExtendedPoint(_ value: ExtendedPoint)

    @objc(addExtendedPoint:)
    @NSManaged public func addToExtendedPoint(_ values: NSSet)

    @objc(removeExtendedPoint:)
    @NSManaged public func removeFromExtendedPoint(_ values: NSSet)

}
