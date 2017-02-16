import Foundation
import CoreData

class ServicesModel {
    let mainContext: NSManagedObjectContext
    
    private let updateQueue = DispatchQueue(label: "ServicesModelUpdate")
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
    }
    
    func updateServicesInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        let networkContext = CoreDataManager.instance.concurrentContext()
        servicesFromNetwork(context: networkContext, onError: onError) {[unowned self] netServices in
            self.updateQueue.sync {
                let storageContext = CoreDataManager.instance.concurrentContext()
                let storedServices: [Service] = CoreDataManager.instance.fetch("Service", from: storageContext)
                
                //Удаляем элементы, которые удалены на сервере
                for service in storedServices {
                    if !netServices.contains(where: {$0 == service}) {
                        storageContext.delete(service)
                    }
                }
                
                //Удаляем полученные элементы, которые уже есть в хранилище
                for service in netServices {
                    if storedServices.contains(where: {$0 == service}) {
                        networkContext.delete(service)
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
    
    func servicesFromNetwork(context: NSManagedObjectContext, onError: @escaping (NetworkError) -> Void, onSuccess: @escaping ([Service]) -> Void) {
        NetworkManager.get("/services", onError: onError) { json in
            let services = json.arrayValue.map() { Service.from(json: $0, context: context) }
            onSuccess(services)
        }
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
