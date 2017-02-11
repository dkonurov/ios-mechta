import Foundation
import CoreData

class OffersModel {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func offersFromNetwork(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping ([Offer]) -> Void) {
        NetworkManager.get("offers", onError: onError) { [unowned self] json in
            let offers = json.arrayValue.map() { Offer.from(json: $0, context: self.context) }
            onSuccess(offers)
        }
    }
}
