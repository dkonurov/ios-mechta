import Foundation
import CoreData
import CoreDataBoilerplate

class CoreDataManager {
    static let instance = CoreDataManager()
    
    var mainContext: NSManagedObjectContext
    
    private init() {
        mainContext = try! NSManagedObjectContext(modelName: "Model", dbStoreName: "Store", concurrencyType: .mainQueueConcurrencyType)
    }
    
    func concurrentContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        return context
    }
    
    func fetchedResultController<T>(entityName: String, predicate: NSPredicate? = nil, orderBy: String, ascending: Bool = false) -> NSFetchedResultsController<T> {
        return mainContext.fetchedController(entityName: entityName, predicate: predicate, orderBy: orderBy, ascending: ascending)
    }
    
    func fetch<T: NSFetchRequestResult>(_ entityName: String, predicate: NSPredicate? = nil, from context: NSManagedObjectContext? = nil) -> [T] {
        let request = NSFetchRequest<T>(entityName: entityName)
        if predicate != nil {
            request.predicate = predicate
        }
        return (try? (context ?? mainContext).fetch(request)) ?? []
    }
}
