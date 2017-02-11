import Foundation
import CoreData

class NewsModel {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func newsFromNetwork(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping ([News]) -> Void) {
        NetworkManager.get("news", onError: onError) { [unowned self] json in
            let news = json.arrayValue.map() { News.from(json: $0, context: self.context) }
            onSuccess(news)
        }
    }
}
