import Foundation
import CoreData
import UIKit

class ServicesFacade {
    static let updatedNotification = NSNotification.Name("ServicesUpdated")
    static let errorNotification = NSNotification.Name("ServicesError")
    static let noNetworkNotification = NSNotification.Name("ServicesNoNetwork")
    
    private let model: ServicesModel
    
    init() {
        self.model = AppModel.instance.servicesModel
    }
    
    func fetchedResultControllerAll() -> NSFetchedResultsController<Service> {
        return CoreDataManager.instance.fetchedResultController(entityName: "Service", orderBy: "published_at")
    }
    
    func fetchedResultControllerInternalServices() -> NSFetchedResultsController<Service> {
        let predicate = NSPredicate(format: "type == %@", Service.ServiceType.internalService.rawValue)
        return CoreDataManager.instance.fetchedResultController(entityName: "Service", predicate: predicate, orderBy: "published_at")
    }
    
    func fetchedResultControllerExternalServices() -> NSFetchedResultsController<Service> {
        let predicate = NSPredicate(format: "type == %@", Service.ServiceType.externalService.rawValue)
        return CoreDataManager.instance.fetchedResultController(entityName: "Service", predicate: predicate, orderBy: "published_at")
    }
    
    func showDetailsPage(service: Service) {
        guard let detailUrl = service.detailUrl else {
            return
        }
        
        let url = URL(string: detailUrl)!
        UIApplication.shared.openURL(url)
    }
    
    var hasServices: Bool {
        return model.servicesFromStorage().count > 0
    }
    
    var hasInternalServices: Bool {
        return model.servicesFromStorage(type: .internalService).count > 0
    }
    
    var hasExternalServices: Bool {
        return model.servicesFromStorage(type: .externalService).count > 0
    }
    
    var unviewedServicesCount: Int {
        return model.unviewedServicesFromStorage().count
    }
    
    func updateServices() {
        model.updateServicesInStorage(onError: onError, onSuccess: onUpdateSuccess)
    }
    
    func onError(error: NetworkError) {
        switch error {
        case .fault(_): NotificationCenter.default.post(name: ServicesFacade.errorNotification, object: nil)
        case .offline: NotificationCenter.default.post(name: ServicesFacade.noNetworkNotification, object: nil)
        }
    }
    
    func onUpdateSuccess() {
        NotificationCenter.default.post(name: ServicesFacade.updatedNotification, object: nil)
    }
    
    func markViewed(_ service: Service) {
        model.markViewed(service)
    }
}
