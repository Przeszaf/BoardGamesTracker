//
//  AdditionalBool+CoreDataProperties.swift
//  BoardGamesTracker
//
//  Created by Przemyslaw Szafulski on 21/03/2018.
//  Copyright © 2018 Przemyslaw Szafulski. All rights reserved.
//
//

import Foundation
import CoreData


extension AdditionalBool {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AdditionalBool> {
        return NSFetchRequest<AdditionalBool>(entityName: "AdditionalBool")
    }

    @NSManaged public var name: String?
    @NSManaged public var game: Game?
    @NSManaged public var matches: Match?

}
