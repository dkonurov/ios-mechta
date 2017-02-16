import Foundation
import CoreData

class ServicesModel {
    let mainContext: NSManagedObjectContext
    let networkManager = NetworkManager()
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
    }
    
    func updateServicesInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        networkManager.updateItemsInStorage(
            serviceMethod: "/services",
            itemParser: Service.from,
            entityName: "Service",
            comparator: {$0 == $1},
            onError: onError,
            onSuccess: onSuccess)
    }
    
    func servicesFromStorage() -> [Service] {
        return CoreDataManager.instance.fetch("Service")
    }
    
    func servicesFromStorage(type: Service.ServiceType) -> [Service] {
        let predicate = NSPredicate(format: "typeRaw == %@", type.rawValue)
        return CoreDataManager.instance.fetch("Service", predicate: predicate)
    }
    
    func unviewedServicesFromStorage() -> [Service] {
        let predicate = NSPredicate(format: "viewed == %d", NSNumber(booleanLiteral: false))
        return CoreDataManager.instance.fetch("Service", predicate: predicate)
    }
    
    func markViewed(_ service: Service) {
        service.viewed = true
        try? service.managedObjectContext?.saveIfNeeded()
        try? mainContext.saveIfNeeded()
    }
}
