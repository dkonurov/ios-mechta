import Foundation
import CoreData

class ExcursionsModel {
    let mainContext: NSManagedObjectContext
    let networkManager = NetworkManager()
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
    }
    
    func updateExcursionsInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        networkManager.updateItemsInStorage(
            serviceMethod: "/excursions",
            itemParser: Excursion.from,
            entityName: "Excursion",
            comparator: {$0 == $1},
            onError: onError,
            onSuccess: onSuccess)
    }
    
    func excursionsFromStorage() -> [Excursion] {
        return CoreDataManager.instance.fetch("Excursion")
    }
    
    func unviewedExcursionsFromStorage() -> [Service] {
        let predicate = NSPredicate(format: "viewed == %d", NSNumber(booleanLiteral: false))
        return CoreDataManager.instance.fetch("Excursion", predicate: predicate)
    }
    
    func markViewed(_ excursion: Excursion) {
        excursion.viewed = true
        try? excursion.managedObjectContext?.saveIfNeeded()
        try? mainContext.saveIfNeeded()
    }
}
