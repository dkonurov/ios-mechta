import Foundation
import CoreData

class ServicesModel {
    let mainContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
    }
    
    func updateServicesInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        let storageContext = CoreDataManager.instance.concurrentContext()
        let storedServices: [Service] = CoreDataManager.instance.fetch("Service", from: storageContext)
        
        let networkContext = CoreDataManager.instance.concurrentContext()
        servicesFromNetwork(context: networkContext, onError: onError) {[unowned self] netServices in
            //Удаляем новости, которые удалены на сервере
            for service in storedServices {
                if !netServices.contains(service) {
                    storageContext.delete(service)
                }
            }
            
            //Удаляем полученные элементы, которые уже есть в хранилище
            for service in netServices {
                if storedServices.contains(service) {
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
    
    func servicesFromNetwork(context: NSManagedObjectContext, onError: @escaping (NetworkError) -> Void, onSuccess: @escaping ([Service]) -> Void) {
        NetworkManager.get("services", onError: onError) { json in
            let services = json.arrayValue.map() { Service.from(json: $0, context: context) }
            onSuccess(services)
        }
    }
    
    func servicesFromStorage() -> [Service] {
        return CoreDataManager.instance.fetch("Service")
    }
}
