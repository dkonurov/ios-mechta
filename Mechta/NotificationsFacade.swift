import Foundation
import CoreData
import UIKit

class NotificationsFacade {
    static let updatedNotification = NSNotification.Name("NotificationsUpdated")
    static let errorNotification = NSNotification.Name("NotificationsError")
    static let noNetworkNotification = NSNotification.Name("NotificationsNoNetwork")
    
    private let model: NotificationsModel
    
    init() {
        self.model = AppModel.instance.notificationsModel
    }
    
    func fetchedResultController() -> NSFetchedResultsController<Notification> {
        let predicate = NSPredicate(format: "hidden == %@", NSNumber(booleanLiteral: false))
        return CoreDataManager.instance.fetchedResultController(entityName: "Notification", predicate: predicate, orderBy: "timeStamp")
    }
    
    func hide(notification: Notification) {
        model.hide(notification: notification)
    }
    
    var hasNotifications: Bool {
        return model.notificationsFromStorage().count > 0
    }
    
    func updateNotifications() {
        model.updateNotificationsInStorage(onError: onError, onSuccess: onUpdateSuccess)
    }
    
    func onError(error: NetworkError) {
        switch error {
        case .fault(_): NotificationCenter.default.post(name: NotificationsFacade.errorNotification, object: nil)
        case .offline: NotificationCenter.default.post(name: NotificationsFacade.noNetworkNotification, object: nil)
        }
    }
    
    func onUpdateSuccess() {
        NotificationCenter.default.post(name: NotificationsFacade.updatedNotification, object: nil)
    }
}
