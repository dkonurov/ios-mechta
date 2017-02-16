import Foundation
import CoreData

class NotificationsModel {
    let mainContext: NSManagedObjectContext
    let networkManager = NetworkManager()
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
    }
    
    func updateNotificationsInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        networkManager.updateItemsInStorage(
            serviceMethod: "/notifications",
            itemParser: Notification.from,
            entityName: "Notification",
            comparator: {$0 == $1},
            onError: onError,
            onSuccess: onSuccess)
    }
    
    func notificationsFromStorage() -> [Notification] {
        let predicate = NSPredicate(format: "hidden == %@", NSNumber(booleanLiteral: false))
        return CoreDataManager.instance.fetch("Notification", predicate: predicate)
    }
    
    func hide(notification: Notification) {
        notification.hidden = true
        try? notification.managedObjectContext?.saveIfNeeded()
        try? mainContext.saveIfNeeded()
    }
}
