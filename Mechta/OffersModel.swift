import Foundation
import CoreData

class OffersModel {
    let mainContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
    }
    
    func updateOffersInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        let storageContext = CoreDataManager.instance.concurrentContext()
        let storedOffers: [Offer] = CoreDataManager.instance.fetch("Offer", from: storageContext)
        
        let networkContext = CoreDataManager.instance.concurrentContext()
        offersFromNetwork(context: networkContext, onError: onError) {[unowned self] netOffers in
            //Удаляем новости, которые удалены на сервере
            for offer in storedOffers {
                if !netOffers.contains(offer) {
                    storageContext.delete(offer)
                }
            }
            
            //Удаляем полученные элементы, которые уже есть в хранилище
            for offer in netOffers {
                if storedOffers.contains(offer) {
                    networkContext.delete(offer)
                }
            }
            
            //Сохраняем контекст
            try? networkContext.saveIfNeeded()
            try? storageContext.saveIfNeeded()
            try? self.mainContext.saveIfNeeded()
            
            onSuccess()
        }
    }
    
    func offersFromNetwork(context: NSManagedObjectContext, onError: @escaping (NetworkError) -> Void, onSuccess: @escaping ([Offer]) -> Void) {
        NetworkManager.get("offers", onError: onError) { json in
            let offers = json.arrayValue.map() { Offer.from(json: $0, context: context) }
            onSuccess(offers)
        }
    }
    
    func offersFromStorage() -> [Offer] {
        return CoreDataManager.instance.fetch("Offer")
    }
}
