//
//  News+CoreDataClass.swift
//  
//
//  Created by Евгений Сафронов on 07.02.17.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(News)
public class News: NSManagedObject {
    
    static func from(json: JSON, context: NSManagedObjectContext) -> News {
        let news: News = context.inserting(entityName: "News")
        news.id = json["id"].int64!
        news.publishedAt = json["published_at"].fromDate(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") as NSDate?
        news.title = json["title"].string
        news.detailUrl = json["detail_url"].string
        news.itemDescription = json["description"].string
        news.photo = json["photo"].string
        return news
    }
    
    var photoUrl: String? {
        return photo == nil ? nil : Constants.imagesUrl + photo!
    }
}
