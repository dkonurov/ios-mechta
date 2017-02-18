import Foundation
import CoreData
import UIKit

class OffersFacade {
    var onUpdate: (() -> Void)?
    var onError: (() -> Void)?
    var onNoNetwork: (() -> Void)?
    
    private let model: OffersModel
    
    init() {
        self.model = AppModel.instance.offersModel
    }
    
    func fetchedResultController() -> NSFetchedResultsController<Offer> {
        return CoreDataManager.instance.fetchedResultController(entityName: "Offer", orderBy: "publishedAt")
    }
    
    func showDetailsPage(offer: Offer) {
        guard let detailUrl = offer.detailUrl else {
            return
        }
        
        if let url = URL(string: detailUrl) {
            UIApplication.shared.openURL(url)
        }
        
        model.markViewed(offer)
    }
    
    var hasOffers: Bool {
        return model.offersFromStorage().count > 0
    }
    
    var unviewedOffersCount: Int {
        return model.unviewedOffersFromStorage().count
    }
    
    func updateOffers() {
        model.updateOffersInStorage(onError: onError, onSuccess: onUpdateSuccess)
    }
    
    func onError(error: NetworkError) {
        switch error {
        case .fault(_): onError?()
        case .offline: onNoNetwork?()
        }
    }
    
    func onUpdateSuccess() {
        onUpdate?()
    }
}
