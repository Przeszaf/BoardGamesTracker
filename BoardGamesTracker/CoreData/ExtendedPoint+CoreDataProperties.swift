//
//  ExtendedPoint+CoreDataProperties.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 27/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//
//

import Foundation
import CoreData


extension ExtendedPoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExtendedPoint> {
        return NSFetchRequest<ExtendedPoint>(entityName: "ExtendedPoint")
    }

    @NSManaged public var name: String?
    @NSManaged public var point: Int32
    @NSManaged public var result: PlayerResult?

}
