import Foundation
import CoreData
import UIKit

class NewsFacade {
    var onUpdate: (() -> Void)?
    var onError: (() -> Void)?
    var onNoNetwork: (() -> Void)?
    
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
        case .fault(_): onError?()
        case .offline: onNoNetwork?()
        }
    }
    
    func onUpdateSuccess() {
        onUpdate?()
    }
}
