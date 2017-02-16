import Foundation
import CoreData

class OffersModel {
    let mainContext: NSManagedObjectContext
    let networkManager = NetworkManager()
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
    }
    
    func updateOffersInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        networkManager.updateItemsInStorage(
            serviceMethod: "/offers",
            itemParser: Offer.from,
            entityName: "Offer",
            comparator: {$0 == $1},
            onError: onError,
            onSuccess: onSuccess)
    }
    
    func offersFromStorage() -> [Offer] {
        return CoreDataManager.instance.fetch("Offer")
    }
    
    func unviewedOffersFromStorage() -> [Service] {
        let predicate = NSPredicate(format: "viewed == %d", NSNumber(booleanLiteral: false))
        return CoreDataManager.instance.fetch("Offer", predicate: predicate)
    }
    
    func markViewed(_ offer: Offer) {
        offer.viewed = true
        try? offer.managedObjectContext?.saveIfNeeded()
        try? mainContext.saveIfNeeded()
    }
}
