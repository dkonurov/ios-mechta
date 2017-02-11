import Foundation
import CoreData
import UIKit

class NewsFacade {
    private let model: NewsModel
    
    init() {
        self.model = AppModel.instance.newsModel
    }
    
    func fetchedResultController() -> NSFetchedResultsController<News> {
        return CoreDataManager.instance.fetchedResultController(entityName: "News", orderBy: "published_at")
    }
    
    func showDetailsPage(news: News) {
        guard let detailUrl = news.detailUrl else {
            return
        }
        
        let url = URL(string: detailUrl)!
        UIApplication.shared.openURL(url)
    }
}
