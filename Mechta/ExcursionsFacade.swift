import Foundation
import CoreData
import UIKit

class ExcursionsFacade {
    static let updatedNotification = NSNotification.Name("ExcursionsUpdated")
    static let errorNotification = NSNotification.Name("ExcursionsError")
    static let noNetworkNotification = NSNotification.Name("ExcursionsNoNetwork")
    
    private let model: ExcursionsModel
    
    init() {
        self.model = AppModel.instance.excursionsModel
    }
    
    func fetchedResultController() -> NSFetchedResultsController<Excursion> {
        return CoreDataManager.instance.fetchedResultController(entityName: "Excursion", orderBy: "startDate", ascending: true)
    }
    
    func showDetailsPage(excursion: Excursion) {
        guard let detailUrl = excursion.detailUrl else {
            return
        }
        
        if let url = URL(string: detailUrl) {
            UIApplication.shared.openURL(url)
        }
        
        model.markViewed(excursion)
    }
    
    var hasExcursions: Bool {
        return model.excursionsFromStorage().count > 0
    }
    
    var unviewedExcursionsCount: Int {
        return model.unviewedExcursionsFromStorage().count
    }
    
    func updateExcursions() {
        model.updateExcursionsInStorage(onError: onError, onSuccess: onUpdateSuccess)
    }
    
    func onError(error: NetworkError) {
        switch error {
        case .fault(_): NotificationCenter.default.post(name: ExcursionsFacade.errorNotification, object: nil)
        case .offline: NotificationCenter.default.post(name: ExcursionsFacade.noNetworkNotification, object: nil)
        }
    }
    
    func onUpdateSuccess() {
        NotificationCenter.default.post(name: ExcursionsFacade.updatedNotification, object: nil)
    }
}
