import Foundation
import CoreData

class NewsModel {
    let mainContext: NSManagedObjectContext
    let networkManager = NetworkManager()
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
    }
    
    func updateNewsInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        networkManager.updateItemsInStorage(
            serviceMethod: "/news",
            itemParser: News.from,
            entityName: "News",
            comparator: {$0 == $1},
            onError: onError,
            onSuccess: onSuccess)
    }
    
    func newsFromStorage() -> [News] {
        return CoreDataManager.instance.fetch("News")
    }
    
    func unviewedNewsFromStorage() -> [Service] {
        let predicate = NSPredicate(format: "viewed == %d", NSNumber(booleanLiteral: false))
        return CoreDataManager.instance.fetch("News", predicate: predicate)
    }
    
    func markViewed(_ news: News) {
        news.viewed = true
        try? news.managedObjectContext?.saveIfNeeded()
        try? mainContext.saveIfNeeded()
    }
}
