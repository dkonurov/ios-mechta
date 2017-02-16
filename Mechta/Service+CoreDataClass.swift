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
    
    enum ServiceType: String {
        case internalService = "internal"
        case externalService = "external"
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
    
    var photoUrl: String? {
        return photo == nil ? nil : Constants.imagesUrl + photo!
    }
    
    var type: ServiceType {
        if typeRaw == nil {
            return .externalService
        }
        
        switch typeRaw! {
        case ServiceType.internalService.rawValue: return .internalService
        case ServiceType.externalService.rawValue: return .externalService
        default: return .externalService
        }
    }
    
}

func == (left: Service, right: Service) -> Bool {
    return left.id == right.id &&
        left.title == right.title &&
        left.detailUrl == right.detailUrl &&
        left.typeRaw == right.typeRaw &&
        left.itemDescription == right.itemDescription &&
        left.publishedAt == right.publishedAt &&
        left.photo == right.photo
}
