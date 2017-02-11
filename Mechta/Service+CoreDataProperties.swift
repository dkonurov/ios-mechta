//
//  Service+CoreDataProperties.swift
//  
//
//  Created by Евгений Сафронов on 07.02.17.
//
//

import Foundation
import CoreData


extension Service {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Service> {
        return NSFetchRequest<Service>(entityName: "Service");
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var detailUrl: String?
    @NSManaged public var itemDescription: String?
    @NSManaged public var typeRaw: String?
    @NSManaged public var publishedAt: NSDate?
    @NSManaged public var photo: String?
    @NSManaged public var viewed: Bool

}
