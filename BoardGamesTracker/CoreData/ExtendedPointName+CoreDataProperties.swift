//
//  ExtendedPointName+CoreDataProperties.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 22/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//
//

import Foundation
import CoreData


extension ExtendedPointName {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExtendedPointName> {
        return NSFetchRequest<ExtendedPointName>(entityName: "ExtendedPointName")
    }

    @NSManaged public var name: String?
    @NSManaged public var game: Game?

}
