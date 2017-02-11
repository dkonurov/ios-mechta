import Foundation
import CoreData

class ServicesModel {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func servicesFromNetwork(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping ([Service]) -> Void) {
        NetworkManager.get("services", onError: onError) { [unowned self] json in
            let services = json.arrayValue.map() { Service.from(json: $0, context: self.context) }
            onSuccess(services)
        }
    }
}
