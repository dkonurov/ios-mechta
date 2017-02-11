//
//  News+CoreDataProperties.swift
//  
//
//  Created by Евгений Сафронов on 07.02.17.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News");
    }

    @NSManaged public var id: Int64
    @NSManaged public var publishedAt: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var detailUrl: String?
    @NSManaged public var itemDescription: String?
    @NSManaged public var photo: String?
    @NSManaged public var viewed: Bool

}
