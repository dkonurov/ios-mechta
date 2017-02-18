import Foundation
import CoreData
import UIKit

class ExcursionsFacade {
    var onUpdate: (() -> Void)?
    var onError: (() -> Void)?
    var onNoNetwork: (() -> Void)?
    
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
        case .fault(_): onError?()
        case .offline: onNoNetwork?()
        }
    }
    
    func onUpdateSuccess() {
        onUpdate?()
    }
}
