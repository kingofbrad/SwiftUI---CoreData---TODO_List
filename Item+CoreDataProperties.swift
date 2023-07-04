//
//  Item+CoreDataProperties.swift
//  Learning Core Data
//
//  Created by Bradlee King on 30/06/2023.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var firstname: String?
    @NSManaged public var surename: String?
    @NSManaged public var gender: String?
    @NSManaged public var age: Int16

}

extension Item : Identifiable {

}
