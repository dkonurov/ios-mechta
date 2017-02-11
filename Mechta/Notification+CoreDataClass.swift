//
//  Notification+CoreDataClass.swift
//  
//
//  Created by Евгений Сафронов on 07.02.17.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Notification)
public class Notification: NSManagedObject {
    
    enum NotificationType {
        case declinedBus
        case delayBus
        case roadSituation
        case adjustmentBus
        case lastBus
        case unknown
    }
    
    static func from(json: JSON, context: NSManagedObjectContext) -> Notification {
        let notification: Notification = context.inserting(entityName: "Notification")
        notification.id = json["id"].int64!
        notification.text = json["body"].string
        notification.timeStamp = json["published_at"].fromDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") as NSDate?
        notification.typeRaw = json["push_type"].string
        return notification
    }
    
    public static func ==(left: Notification, right: Notification) -> Bool{
        return left.id == right.id
    }
    
    var type: NotificationType {
        if typeRaw == nil {
            return .unknown
        }
        
        switch typeRaw! {
        case "declined_bus": return .declinedBus
        case "delay_bus": return .delayBus
        case "road_situation": return .roadSituation
        case "adjustment_bus": return .adjustmentBus
        case "last_bus": return .lastBus
        default: return .unknown
        }
    }
    
}
