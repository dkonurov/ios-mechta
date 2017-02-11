import Foundation
import CoreData
import UIKit

class OffersFacade {
    private let model: OffersModel
    
    init() {
        self.model = AppModel.instance.offersModel
    }
    
    func fetchedResultController() -> NSFetchedResultsController<Offer> {
        return CoreDataManager.instance.fetchedResultController(entityName: "Offer", orderBy: "published_at")
    }
    
    func showDetailsPage(offer: Offer) {
        guard let detailUrl = offer.detailUrl else {
            return
        }
        
        let url = URL(string: detailUrl)!
        UIApplication.shared.openURL(url)
    }
}
