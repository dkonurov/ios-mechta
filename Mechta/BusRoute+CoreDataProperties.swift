//
//  BusRoute+CoreDataProperties.swift
//  
//
//  Created by Evgeniy Safronov on 16.02.17.
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
    @NSManaged public var flights: NSOrderedSet?

}

// MARK: Generated accessors for flights
extension BusRoute {

    @objc(insertObject:inFlightsAtIndex:)
    @NSManaged public func insertIntoFlights(_ value: BusRouteFlight, at idx: Int)

    @objc(removeObjectFromFlightsAtIndex:)
    @NSManaged public func removeFromFlights(at idx: Int)

    @objc(insertFlights:atIndexes:)
    @NSManaged public func insertIntoFlights(_ values: [BusRouteFlight], at indexes: NSIndexSet)

    @objc(removeFlightsAtIndexes:)
    @NSManaged public func removeFromFlights(at indexes: NSIndexSet)

    @objc(replaceObjectInFlightsAtIndex:withObject:)
    @NSManaged public func replaceFlights(at idx: Int, with value: BusRouteFlight)

    @objc(replaceFlightsAtIndexes:withFlights:)
    @NSManaged public func replaceFlights(at indexes: NSIndexSet, with values: [BusRouteFlight])

    @objc(addFlightsObject:)
    @NSManaged public func addToFlights(_ value: BusRouteFlight)

    @objc(removeFlightsObject:)
    @NSManaged public func removeFromFlights(_ value: BusRouteFlight)

    @objc(addFlights:)
    @NSManaged public func addToFlights(_ values: NSOrderedSet)

    @objc(removeFlights:)
    @NSManaged public func removeFromFlights(_ values: NSOrderedSet)

}
