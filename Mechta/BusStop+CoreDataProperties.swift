//
//  BusStop+CoreDataProperties.swift
//  
//
//  Created by Evgeniy Safronov on 14.02.17.
//
//

import Foundation
import CoreData


extension BusStop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusStop> {
        return NSFetchRequest<BusStop>(entityName: "BusStop");
    }

    @NSManaged public var title: String?
    @NSManaged public var id: Int64
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
