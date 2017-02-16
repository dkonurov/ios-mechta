//
//  Notification+CoreDataProperties.swift
//  
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation
import CoreData


extension Notification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notification> {
        return NSFetchRequest<Notification>(entityName: "Notification");
    }

    @NSManaged public var hidden: Bool
    @NSManaged public var id: Int64
    @NSManaged public var text: String?
    @NSManaged public var timeStamp: NSDate?
    @NSManaged public var typeRaw: String?

}
