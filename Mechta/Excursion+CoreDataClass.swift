//
//  Excursion+CoreDataClass.swift
//  
//
//  Created by Евгений Сафронов on 07.02.17.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Excursion)
public class Excursion: NSManagedObject {

    static func from(json: JSON, context: NSManagedObjectContext) -> Excursion {
        let excursion: Excursion = context.inserting(entityName: "Excursion")
        excursion.id = json["id"].int64!
        excursion.startDate = json["start_date"].fromDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") as NSDate?
        excursion.title = json["title"].string
        excursion.detailUrl = json["detail_url"].string
        excursion.itemDescription = json["description"].string
        excursion.publishedAt = json["published_at"].fromDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") as NSDate?
        excursion.photo = json["photo"].string
        return excursion
    }
    
    public static func ==(left: Excursion, right: Excursion) -> Bool{
        return left.id == right.id
    }
}
