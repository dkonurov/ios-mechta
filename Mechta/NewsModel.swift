import Foundation
import CoreData

class NewsModel {
    let mainContext: NSManagedObjectContext
    
    private let updateQueue = DispatchQueue(label: "NewsModelUpdate")
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
    }
    
    func updateNewsInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        let networkContext = CoreDataManager.instance.concurrentContext()
        newsFromNetwork(context: networkContext, onError: onError) {[unowned self] netNews in
            self.updateQueue.sync {
                let storageContext = CoreDataManager.instance.concurrentContext()
                let storedNews: [News] = CoreDataManager.instance.fetch("News", from: storageContext)
                
                //Удаляем новости, которые удалены на сервере
                for news in storedNews {
                    if !netNews.contains(where: {$0.id == news.id}) {
                        storageContext.delete(news)
                    }
                }
                
                //Удаляем полученные элементы, которые уже есть в хранилище
                for news in netNews {
                    if storedNews.contains(where: {$0.id == news.id}) {
                        networkContext.delete(news)
                    }
                }
                
                //Сохраняем контекст
                try? networkContext.saveIfNeeded()
                try? storageContext.saveIfNeeded()
                try? self.mainContext.saveIfNeeded()
                
                onSuccess()
            }
        }
    }
    
    func newsFromNetwork(context: NSManagedObjectContext, onError: @escaping (NetworkError) -> Void, onSuccess: @escaping ([News]) -> Void) {
        NetworkManager.get("/news", onError: onError) { json in
            let news = json.arrayValue.map() { News.from(json: $0, context: context) }
            onSuccess(news)
        }
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
