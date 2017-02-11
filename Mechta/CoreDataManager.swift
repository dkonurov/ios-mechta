import Foundation
import CoreData
import CoreDataBoilerplate

class CoreDataManager {
    static let instance = CoreDataManager()
    
    var mainContext: NSManagedObjectContext
    var bgContext: NSManagedObjectContext
    
    private init() {
        mainContext = try! NSManagedObjectContext(modelName: "Model", dbStoreName: "Store", concurrencyType: .mainQueueConcurrencyType)
        bgContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        bgContext.parent = mainContext
    }
    
    func fetchedResultController<T>(entityName: String, predicate: NSPredicate? = nil, orderBy: String, ascending: Bool = false) -> NSFetchedResultsController<T> {
        return mainContext.fetchedController(entityName: entityName, predicate: predicate, orderBy: orderBy, ascending: ascending)
    }
    
    func save() {
        try! bgContext.saveIfNeeded()
        try! mainContext.saveIfNeeded()
    }
}
