import Foundation
import CoreData
import UIKit

class OffersFacade {
    static let updatedNotification = NSNotification.Name("OffersUpdated")
    static let errorNotification = NSNotification.Name("OffersError")
    static let noNetworkNotification = NSNotification.Name("OffersNoNetwork")
    
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
        case .fault(_): NotificationCenter.default.post(name: OffersFacade.errorNotification, object: nil)
        case .offline: NotificationCenter.default.post(name: OffersFacade.noNetworkNotification, object: nil)
        }
    }
    
    func onUpdateSuccess() {
        NotificationCenter.default.post(name: OffersFacade.updatedNotification, object: nil)
    }
}
