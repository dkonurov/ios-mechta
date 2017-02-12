//
//  Offer+CoreDataProperties.swift
//  
//
//  Created by Evgeniy Safronov on 12.02.17.
//
//

import Foundation
import CoreData


extension Offer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Offer> {
        return NSFetchRequest<Offer>(entityName: "Offer");
    }

    @NSManaged public var detailUrl: String?
    @NSManaged public var id: Int64
    @NSManaged public var itemDescription: String?
    @NSManaged public var photo: String?
    @NSManaged public var publishedAt: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var viewed: Bool

}
