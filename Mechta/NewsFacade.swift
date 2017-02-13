import Foundation
import CoreData
import UIKit

class NewsFacade {
    static let updatedNotification = NSNotification.Name("NewsUpdated")
    static let errorNotification = NSNotification.Name("NewsError")
    static let noNetworkNotification = NSNotification.Name("NewsNoNetwork")
    
    private let model: NewsModel
    
    init() {
        self.model = AppModel.instance.newsModel
    }
    
    func fetchedResultController() -> NSFetchedResultsController<News> {
        return CoreDataManager.instance.fetchedResultController(entityName: "News", orderBy: "publishedAt")
    }
    
    func showDetailsPage(news: News) {
        guard let detailUrl = news.detailUrl else {
            return
        }
        
        if let url = URL(string: detailUrl) {
            UIApplication.shared.openURL(url)
        }
        
        model.markViewed(news)
    }
    
    var hasNews: Bool {
        return model.newsFromStorage().count > 0
    }
    
    var unviewedNewsCount: Int {
        return model.unviewedNewsFromStorage().count
    }
    
    func updateNews() {
        model.updateNewsInStorage(onError: onError, onSuccess: onUpdateSuccess)
    }
    
    func onError(error: NetworkError) {
        switch error {
        case .fault(_): NotificationCenter.default.post(name: NewsFacade.errorNotification, object: nil)
        case .offline: NotificationCenter.default.post(name: NewsFacade.noNetworkNotification, object: nil)
        }
    }
    
    func onUpdateSuccess() {
        NotificationCenter.default.post(name: NewsFacade.updatedNotification, object: nil)
    }
}
