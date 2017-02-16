//
//  BusRouteFlight+CoreDataProperties.swift
//  
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation
import CoreData


extension BusRouteFlight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusRouteFlight> {
        return NSFetchRequest<BusRouteFlight>(entityName: "BusRouteFlight");
    }

    @NSManaged public var express: Bool
    @NSManaged public var id: Int64
    @NSManaged public var weekendAvailability: Bool
    @NSManaged public var workingDaysAvailability: Bool
    @NSManaged public var busRoute: BusRoute?
    @NSManaged public var stops: NSOrderedSet?

}

// MARK: Generated accessors for stops
extension BusRouteFlight {

    @objc(insertObject:inStopsAtIndex:)
    @NSManaged public func insertIntoStops(_ value: BusRouteFlightStop, at idx: Int)

    @objc(removeObjectFromStopsAtIndex:)
    @NSManaged public func removeFromStops(at idx: Int)

    @objc(insertStops:atIndexes:)
    @NSManaged public func insertIntoStops(_ values: [BusRouteFlightStop], at indexes: NSIndexSet)

    @objc(removeStopsAtIndexes:)
    @NSManaged public func removeFromStops(at indexes: NSIndexSet)

    @objc(replaceObjectInStopsAtIndex:withObject:)
    @NSManaged public func replaceStops(at idx: Int, with value: BusRouteFlightStop)

    @objc(replaceStopsAtIndexes:withStops:)
    @NSManaged public func replaceStops(at indexes: NSIndexSet, with values: [BusRouteFlightStop])

    @objc(addStopsObject:)
    @NSManaged public func addToStops(_ value: BusRouteFlightStop)

    @objc(removeStopsObject:)
    @NSManaged public func removeFromStops(_ value: BusRouteFlightStop)

    @objc(addStops:)
    @NSManaged public func addToStops(_ values: NSOrderedSet)

    @objc(removeStops:)
    @NSManaged public func removeFromStops(_ values: NSOrderedSet)

}
