//
//  Service+CoreDataClass.swift
//  
//
//  Created by Евгений Сафронов on 07.02.17.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Service)
public class Service: NSManagedObject {
    
    enum ServiceType {
        case internalService
        case externalService
        case unknownService
    }
    
    static func from(json: JSON, context: NSManagedObjectContext) -> Service {
        let service: Service = context.inserting(entityName: "Service")
        service.id = json["id"].int64!
        service.title = json["title"].string
        service.detailUrl = json["detail_url"].string
        service.itemDescription = json["description"].string
        service.typeRaw = json["service_type"].string
        service.publishedAt = json["published_at"].fromDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") as NSDate?
        service.photo = json["photo"].string
        return service
    }
    
    var type: ServiceType {
        if typeRaw == nil {
            return .unknownService
        }
        
        switch typeRaw! {
        case "internal": return .internalService
        case "external": return .externalService
        default: return .unknownService
        }
    }
    
}
