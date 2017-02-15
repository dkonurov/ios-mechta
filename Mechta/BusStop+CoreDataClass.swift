//
//  BusStop+CoreDataClass.swift
//  
//
//  Created by Evgeniy Safronov on 14.02.17.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(BusStop)
public class BusStop: NSManagedObject {
    static func from(json: JSON, context: NSManagedObjectContext) -> BusStop {
        let busStop: BusStop = context.inserting(entityName: "BusStop")
        busStop.id = json["id"].int64!
        busStop.title = json["title"].string
        busStop.latitude = json["latitude"].double ?? 0
        busStop.longitude = json["longitude"].double ?? 0
        return busStop
    }
    
    static func fetch(id: Int64, context: NSManagedObjectContext) -> BusStop? {
        let request = NSFetchRequest<BusStop>(entityName: "BusStop")
        request.predicate = NSPredicate(format: "id == %d", id)
        return (try? context.fetch(request))?.first
    }
}
