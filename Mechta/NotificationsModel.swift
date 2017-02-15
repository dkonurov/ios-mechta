import Foundation
import CoreData

class NotificationsModel {
    let mainContext: NSManagedObjectContext
    
    private let updateQueue = DispatchQueue(label: "NotificationsModelUpdate")
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
    }
    
    func updateNotificationsInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        let networkContext = CoreDataManager.instance.concurrentContext()
        notificationsFromNetwork(context: networkContext, onError: onError) {[unowned self] netNotifications in
            self.updateQueue.sync {
                let storageContext = CoreDataManager.instance.concurrentContext()
                let storedNotifications: [Notification] = CoreDataManager.instance.fetch("Notification", from: storageContext)
                
                //Удаляем элементы, которые удалены на сервере
                for notification in storedNotifications {
                    if !netNotifications.contains(where: {$0.id == notification.id}) {
                        storageContext.delete(notification)
                    }
                }
                
                //Удаляем полученные элементы, которые уже есть в хранилище
                for notification in netNotifications {
                    if storedNotifications.contains(where: {$0.id == notification.id}) {
                        networkContext.delete(notification)
                    }
                }
                
                //Сохраняем контекст
                try? networkContext.saveIfNeeded()
                try? storageContext.saveIfNeeded()
                try? self.mainContext.saveIfNeeded()
                
                onSuccess()
            }
        }
    }
    
    func notificationsFromNetwork(context: NSManagedObjectContext, onError: @escaping (NetworkError) -> Void, onSuccess: @escaping ([Notification]) -> Void) {
        NetworkManager.get("/notifications", onError: onError) { json in
            let notificationsFromNetwork = json.arrayValue.map() { Notification.from(json: $0, context: context) }
            onSuccess(notificationsFromNetwork)
        }
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
