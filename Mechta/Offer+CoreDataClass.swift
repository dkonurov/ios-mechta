//
//  Offer+CoreDataClass.swift
//  
//
//  Created by Евгений Сафронов on 07.02.17.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Offer)
public class Offer: NSManagedObject {
    
    static func from(json: JSON, context: NSManagedObjectContext) -> Offer {
        let offer: Offer = context.inserting(entityName: "Offer")
        offer.id = json["id"].int64!
        offer.title = json["title"].string
        offer.detailUrl = json["detail_url"].string
        offer.itemDescription = json["description"].string
        offer.publishedAt = json["published_at"].fromDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") as NSDate?
        offer.photo = json["photo"].string
        return offer
    }
    
    var photoUrl: String? {
        return photo == nil ? nil : Constants.imagesUrl + photo!
    }
}
