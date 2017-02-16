//
//  BusRoute+CoreDataClass.swift
//
//
//  Created by Evgeniy Safronov on 14.02.17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData
import SwiftyJSON

@objc(BusRoute)
public class BusRoute: NSManagedObject {
    
    static func from(json: JSON, context: NSManagedObjectContext) -> BusRoute {
        
        let route: BusRoute = context.inserting(entityName: "BusRoute")
        route.id = json["id"].int64!
        route.name = json["name"].string
        
        let flights = json["flights"].arrayValue.map() {BusRouteFlight.from(json: $0, context: context)}
        route.flights = NSSet(array: flights)
        
        return route
        
    }
}

func == (left: BusRoute, right: BusRoute) -> Bool {
    return left.id == right.id &&
        left.name == right.name &&
        left.flights?.count == right.flights?.count &&
        (left.flights?.elementsEqual(right.flights!) {$0 as! BusRouteFlight == $1 as! BusRouteFlight}) ?? true
}
