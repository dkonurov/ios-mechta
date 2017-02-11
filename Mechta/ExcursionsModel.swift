import Foundation
import CoreData

class ExcursionsModel {
    let mainContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
    }
    
    func updateExcursionsInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        let storageContext = CoreDataManager.instance.concurrentContext()
        let storedExcursions: [Excursion] = CoreDataManager.instance.fetch("Excursion", from: storageContext)
        
        let networkContext = CoreDataManager.instance.concurrentContext()
        excursionsFromNetwork(context: networkContext, onError: onError) {[unowned self] netExcursions in
            //Удаляем новости, которые удалены на сервере
            for excursion in storedExcursions {
                if !netExcursions.contains(excursion) {
                    storageContext.delete(excursion)
                }
            }
            
            //Удаляем полученные элементы, которые уже есть в хранилище
            for excursion in netExcursions {
                if storedExcursions.contains(excursion) {
                    networkContext.delete(excursion)
                }
            }
            
            //Сохраняем контекст
            try? networkContext.saveIfNeeded()
            try? storageContext.saveIfNeeded()
            try? self.mainContext.saveIfNeeded()
            
            onSuccess()
        }
    }
    
    func excursionsFromNetwork(context: NSManagedObjectContext, onError: @escaping (NetworkError) -> Void, onSuccess: @escaping ([Excursion]) -> Void) {
        NetworkManager.get("excursions", onError: onError) { json in
            let excursions = json.arrayValue.map() { Excursion.from(json: $0, context: context) }
            onSuccess(excursions)
        }
    }
    
    func excursionsFromStorage() -> [Excursion] {
        return CoreDataManager.instance.fetch("Excursion")
    }
    
    func unviewedExcursionsFromStorage() -> [Service] {
        let predicate = NSPredicate(format: "viewed == %d", NSNumber(booleanLiteral: false))
        return CoreDataManager.instance.fetch("Excursion", predicate: predicate)
    }
}
