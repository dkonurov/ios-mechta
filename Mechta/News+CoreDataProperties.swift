//
//  News+CoreDataProperties.swift
//  
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News");
    }

    @NSManaged public var detailUrl: String?
    @NSManaged public var id: Int64
    @NSManaged public var itemDescription: String?
    @NSManaged public var photo: String?
    @NSManaged public var publishedAt: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var viewed: Bool

}
