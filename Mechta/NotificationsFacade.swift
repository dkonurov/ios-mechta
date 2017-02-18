import Foundation
import CoreData
import UIKit

class NotificationsFacade {
    var onUpdate: (() -> Void)?
    var onError: (() -> Void)?
    var onNoNetwork: (() -> Void)?
    
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
        onUpdateSuccess()
    }
    
    var hasNotifications: Bool {
        return model.notificationsFromStorage().count > 0
    }
    
    var notificationsCount: Int {
        return model.notificationsFromStorage().count
    }
    
    func updateNotifications() {
        model.updateNotificationsInStorage(onError: onError, onSuccess: onUpdateSuccess)
    }
    
    func onError(error: NetworkError) {
        switch error {
        case .fault(_): onError?()
        case .offline: onNoNetwork?()
        }
    }
    
    func onUpdateSuccess() {
        onUpdate?()
    }
}
