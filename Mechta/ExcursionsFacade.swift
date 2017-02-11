import Foundation
import CoreData
import UIKit

class ExcursionsFacade {
    private let model: ExcursionsModel
    
    init() {
        self.model = AppModel.instance.excursionsModel
    }
    
    func fetchedResultController() -> NSFetchedResultsController<Excursion> {
        return CoreDataManager.instance.fetchedResultController(entityName: "Excursion", orderBy: "startDate", ascending: true)
    }
    
    func showDetailsPage(excursion: Excursion) {
        guard let detailUrl = excursion.detailUrl else {
            return
        }
        
        let url = URL(string: detailUrl)!
        UIApplication.shared.openURL(url)
    }
}
