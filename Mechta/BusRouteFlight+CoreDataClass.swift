//
//  BusRouteFlight+CoreDataClass.swift
//  
//
//  Created by Evgeniy Safronov on 14.02.17.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(BusRouteFlight)
public class BusRouteFlight: NSManagedObject {
    
    static func from(json: JSON, context: NSManagedObjectContext) -> BusRouteFlight {
        
        let flight: BusRouteFlight = context.inserting(entityName: "BusRouteFlight")
        flight.id = json["id"].int64!
        flight.express = json["express"].bool ?? false
        flight.weekendAvailability = json["weekend_days_availability"].bool ?? false
        flight.workingDaysAvailability = json["working_days_availability"].bool ?? false
        
        let stops = json["bus_stops"].arrayValue.map() {BusRouteFlightStop.from(json: $0, context: context)}
        flight.stops = NSSet(array: stops)

        return flight
        
    }
}
