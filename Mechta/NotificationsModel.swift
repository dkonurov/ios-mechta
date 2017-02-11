import Foundation
import CoreData

class NotificationsModel {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func notificationsFromNetwork(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping ([Notification]) -> Void) {
        NetworkManager.get("notifications", onError: onError) { [unowned self] json in
            let notificationsFromNetwork = json.arrayValue.map() { Notification.from(json: $0, context: self.context) }
            onSuccess(notificationsFromNetwork)
        }
    }
}
