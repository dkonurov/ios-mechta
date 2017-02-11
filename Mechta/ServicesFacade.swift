import Foundation
import CoreData
import UIKit

class ServicesFacade {
    private let model: ServicesModel
    
    init() {
        self.model = AppModel.instance.servicesModel
    }
    
    func fetchedResultControllerAll() -> NSFetchedResultsController<Service> {
        return CoreDataManager.instance.fetchedResultController(entityName: "Service", orderBy: "published_at")
    }
    
    func fetchedResultControllerInternalServices() -> NSFetchedResultsController<Service> {
        let predicate = NSPredicate(format: "type == .internalService")
        return CoreDataManager.instance.fetchedResultController(entityName: "Service", predicate: predicate, orderBy: "published_at")
    }
    
    func fetchedResultControllerExternalServices() -> NSFetchedResultsController<Service> {
        let predicate = NSPredicate(format: "type == .externalService")
        return CoreDataManager.instance.fetchedResultController(entityName: "Service", predicate: predicate, orderBy: "published_at")
    }
    
    func showDetailsPage(service: Service) {
        guard let detailUrl = service.detailUrl else {
            return
        }
        
        let url = URL(string: detailUrl)!
        UIApplication.shared.openURL(url)
    }
}
