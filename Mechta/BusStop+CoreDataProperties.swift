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

    @NSManaged public var id: Int64
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var title: String?
    @NSManaged public var flightStops: NSSet?

}

// MARK: Generated accessors for flightStops
extension BusStop {

    @objc(addFlightStopsObject:)
    @NSManaged public func addToFlightStops(_ value: BusRouteFlightStop)

    @objc(removeFlightStopsObject:)
    @NSManaged public func removeFromFlightStops(_ value: BusRouteFlightStop)

    @objc(addFlightStops:)
    @NSManaged public func addToFlightStops(_ values: NSSet)

    @objc(removeFlightStops:)
    @NSManaged public func removeFromFlightStops(_ values: NSSet)

}
