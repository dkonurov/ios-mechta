import UIKit
import CoreData

class ExcursionListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    private let model = ExcursionsFacade()
    private var fetchedResultController: NSFetchedResultsController<Excursion>?
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDataUpdated), name: ExcursionsFacade.updatedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateError), name: ExcursionsFacade.errorNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNoNetworkUpdateError), name: ExcursionsFacade.noNetworkNotification, object: nil)
        
        try? fetchedResultController?.performFetch()
        
        model.updateExcursions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func reload() {
        model.updateExcursions()
    }
    
    func onDataUpdated() {
        refreshControl?.endRefreshing()
        
        if model.hasExcursions {
            showContentBackground()
        } else {
            showMessageBackground("Экскурсий нет", subtitle: "Потяните экран, чтобы обновить")
        }
    }
    
    func onUpdateError() {
        if model.hasExcursions {
            showMessageAlert("Не удалось загрузить данные") { [weak self] in
                self?.refreshControl?.endRefreshing()
            }
        } else {
            refreshControl?.endRefreshing()
            showMessageBackground("Ошибка", subtitle: "Не удалось загрузить новости")
        }
    }
    
    func onNoNetworkUpdateError() {
        if model.hasExcursions {
            showMessageAlert("Отсутствует подключение к интернету") {  [weak self] in
                self?.refreshControl?.endRefreshing()
            }
        } else {
            refreshControl?.endRefreshing()
            showMessageBackground("Ошибка", subtitle: "Отсутствует подключение к интернету")
        }
    }
    
    //MARK: Отрисовка таблицы
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultController!.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let excursion = fetchedResultController!.object(at: indexPath)
        let cellId = excursion.photoUrl != nil ? "ExcursionCell" : "ExcursionCellNoPhoto"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ExcursionCell
        cell.show(excursion)
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
                let excursion = fetchedResultController!.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath) as! ExcursionCell
                cell.show(excursion)
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
