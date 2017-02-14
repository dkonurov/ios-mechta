//
//  BusRoute+CoreDataProperties.swift
//  
//
//  Created by Evgeniy Safronov on 14.02.17.
//
//

import Foundation
import CoreData


extension BusRoute {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusRoute> {
        return NSFetchRequest<BusRoute>(entityName: "BusRoute");
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var flights: NSSet?

}

// MARK: Generated accessors for flights
extension BusRoute {

    @objc(addFlightsObject:)
    @NSManaged public func addToFlights(_ value: BusRouteFlight)

    @objc(removeFlightsObject:)
    @NSManaged public func removeFromFlights(_ value: BusRouteFlight)

    @objc(addFlights:)
    @NSManaged public func addToFlights(_ values: NSSet)

    @objc(removeFlights:)
    @NSManaged public func removeFromFlights(_ values: NSSet)

}
