import Foundation
import CoreData
import UIKit

class NotificationsFacade {
    private let model: NotificationsModel
    
    init() {
        self.model = AppModel.instance.notificationsModel
    }
    
    func fetchedResultController() -> NSFetchedResultsController<Notification> {
        return CoreDataManager.instance.fetchedResultController(entityName: "Notification", orderBy: "timeStamp")
    }
    
    func delete(notification: Notification) {
        
    }
}
