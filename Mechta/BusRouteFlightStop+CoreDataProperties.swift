//
//  BusRouteFlightStop+CoreDataProperties.swift
//  
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation
import CoreData


extension BusRouteFlightStop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusRouteFlightStop> {
        return NSFetchRequest<BusRouteFlightStop>(entityName: "BusRouteFlightStop");
    }

    @NSManaged public var stopTime: String?
    @NSManaged public var busStop: BusStop?
    @NSManaged public var flight: BusRouteFlight?

}
