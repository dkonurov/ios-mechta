import Foundation
import CoreData

class ExcursionsModel {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func excursionsFromNetwork(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping ([Excursion]) -> Void) {
        NetworkManager.get("excursions", onError: onError) { [unowned self] json in
            let excursions = json.arrayValue.map() { Excursion.from(json: $0, context: self.context) }
            onSuccess(excursions)
        }
    }
}
