import UIKit
import CoreData

class NewsListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    private let model = NewsFacade()
    private var fetchedResultController: NSFetchedResultsController<News>?
    
    //MARK: Инициализация
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        
        fetchedResultController = model.fetchedResultController()
        fetchedResultController?.delegate = self
    }
    
    //MARK: Обработка событий
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDataUpdated), name: NewsFacade.updatedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateError), name: NewsFacade.errorNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNoNetworkUpdateError), name: NewsFacade.noNetworkNotification, object: nil)
        
        try? fetchedResultController?.performFetch()
        
        model.updateNews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func reload() {
        model.updateNews()
    }
    
    func onDataUpdated() {
        refreshControl?.endRefreshing()
        
        if model.hasNews {
            showContentBackground()
        } else {
            showMessageBackground("Новостей нет", subtitle: "Потяните экран, чтобы обновить")
        }
    }
    
    func onUpdateError() {
        refreshControl?.endRefreshing()
        print("Ошибка обновления")
    }
    
    func onNoNetworkUpdateError() {
        refreshControl?.endRefreshing()
        print("Нет сети")
    }
    
    //MARK: Отрисовка таблицы
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController!.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        let news = fetchedResultController!.object(at: indexPath)
        cell.show(news)
        return cell
    }
    
    //MARK: Отслеживание изменений
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let news = fetchedResultController!.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath) as! NewsCell
                cell.show(news)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
