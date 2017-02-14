//
//  BusRouteFlight+CoreDataProperties.swift
//  
//
//  Created by Evgeniy Safronov on 14.02.17.
//
//

import Foundation
import CoreData


extension BusRouteFlight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusRouteFlight> {
        return NSFetchRequest<BusRouteFlight>(entityName: "BusRouteFlight");
    }

    @NSManaged public var id: Int64
    @NSManaged public var express: Bool
    @NSManaged public var weekendAvailability: Bool
    @NSManaged public var workingDaysAvailability: Bool
    @NSManaged public var busRoute: BusRoute?
    @NSManaged public var stops: NSSet?

}

// MARK: Generated accessors for stops
extension BusRouteFlight {

    @objc(addStopsObject:)
    @NSManaged public func addToStops(_ value: BusRouteFlightStop)

    @objc(removeStopsObject:)
    @NSManaged public func removeFromStops(_ value: BusRouteFlightStop)

    @objc(addStops:)
    @NSManaged public func addToStops(_ values: NSSet)

    @objc(removeStops:)
    @NSManaged public func removeFromStops(_ values: NSSet)

}
