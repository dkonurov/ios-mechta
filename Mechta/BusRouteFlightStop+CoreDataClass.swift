//
//  BusRouteFlightStop+CoreDataClass.swift
//  
//
//  Created by Evgeniy Safronov on 14.02.17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData
import SwiftyJSON

@objc(BusRouteFlightStop)
public class BusRouteFlightStop: NSManagedObject {
    
    static func from(json: JSON, context: NSManagedObjectContext) -> BusRouteFlightStop {
        let stop: BusRouteFlightStop = context.inserting(entityName: "BusRouteFlightStop")
        stop.stopTime = json["stop_time"].string
        
        let busStopId = json["bus_stop_id"].int64!
        stop.busStop = BusStop.fetch(id: busStopId, context: context)
        
        return stop  
    }
}

func == (left: BusRouteFlightStop, right: BusRouteFlightStop) -> Bool {
    return left.stopTime == right.stopTime &&
        left.busStop == right.busStop
}
