import Foundation
import CoreData
import UIKit

class ServicesFacade {
    let updatedNotification: NSNotification.Name
    let errorNotification: NSNotification.Name
    let noNetworkNotification: NSNotification.Name
    
    private let model: ServicesModel
    private let availableTypes: [Service.ServiceType]
    
    init(availableTypes: [Service.ServiceType]) {
        self.model = AppModel.instance.servicesModel
        self.availableTypes = availableTypes
        
        if availableTypes.contains(.externalService) && availableTypes.contains(.internalService) {
            updatedNotification = NSNotification.Name("ServicesUpdated")
            errorNotification = NSNotification.Name("ServicesError")
            noNetworkNotification = NSNotification.Name("ServicesNoNetwork")
        }
        else if availableTypes.contains(.internalService) {
            updatedNotification = NSNotification.Name("InternalServicesUpdated")
            errorNotification = NSNotification.Name("InternalServicesError")
            noNetworkNotification = NSNotification.Name("InternalServicesNoNetwork")
        }
        else {
            updatedNotification = NSNotification.Name("ExternalServicesUpdated")
            errorNotification = NSNotification.Name("ExternalServicesError")
            noNetworkNotification = NSNotification.Name("ExternalServicesNoNetwork")
        }
    }
    
    func fetchedResultController() -> NSFetchedResultsController<Service> {
        if availableTypes.contains(.externalService) && availableTypes.contains(.internalService) {
            return fetchedResultControllerAll()
        }
        
        if availableTypes.contains(.internalService) {
            return fetchedResultControllerInternalServices()
        }
        
        return fetchedResultControllerExternalServices()
    }
    
    private func fetchedResultControllerAll() -> NSFetchedResultsController<Service> {
        return CoreDataManager.instance.fetchedResultController(entityName: "Service", orderBy: "publishedAt")
    }
    
    private func fetchedResultControllerInternalServices() -> NSFetchedResultsController<Service> {
        let predicate = NSPredicate(format: "typeRaw == %@", Service.ServiceType.internalService.rawValue)
        return CoreDataManager.instance.fetchedResultController(entityName: "Service", predicate: predicate, orderBy: "publishedAt")
    }
    
    private func fetchedResultControllerExternalServices() -> NSFetchedResultsController<Service> {
        let predicate = NSPredicate(format: "typeRaw == %@", Service.ServiceType.externalService.rawValue)
        return CoreDataManager.instance.fetchedResultController(entityName: "Service", predicate: predicate, orderBy: "publishedAt")
    }
    
    func showDetailsPage(service: Service) {
        guard let detailUrl = service.detailUrl else {
            return
        }
        
        let url = URL(string: detailUrl)!
        UIApplication.shared.openURL(url)
        
        model.markViewed(service)
    }
    
    var hasServices: Bool {
        if availableTypes.contains(.externalService) && availableTypes.contains(.internalService) {
            return hasAnyServices
        }
        
        if availableTypes.contains(.internalService) {
            return hasInternalServices
        }
        
        return hasExternalServices
    }
    
    private var hasAnyServices: Bool {
        return model.servicesFromStorage().count > 0
    }
    
    private var hasInternalServices: Bool {
        return model.servicesFromStorage(type: .internalService).count > 0
    }
    
    private var hasExternalServices: Bool {
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
        case .fault(_): NotificationCenter.default.post(name: errorNotification, object: nil)
        case .offline: NotificationCenter.default.post(name: noNetworkNotification, object: nil)
        }
    }
    
    func onUpdateSuccess() {
        NotificationCenter.default.post(name: updatedNotification, object: nil)
    }
}
