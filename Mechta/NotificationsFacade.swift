import Foundation
import CoreData
import UIKit

class NotificationsFacade {
    private let model: NotificationsModel
    
    init() {
        self.model = AppModel.instance.notificationsModel
    }
    
    func fetchedResultController() -> NSFetchedResultsController<Notification> {
        let predicate = NSPredicate(format: "hidden == %@", NSNumber(booleanLiteral: false))
        return CoreDataManager.instance.fetchedResultController(entityName: "Notification", predicate: predicate, orderBy: "timeStamp")
    }
    
    func delete(notification: Notification) {
        
    }
}
