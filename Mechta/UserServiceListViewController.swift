import UIKit
import CoreData

class UserServiceListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    private let model = ServicesFacade()
    private var fetchedResultController: NSFetchedResultsController<Service>?
    
    //Из меню настраиваем, какие типы будут доступны в списке
    var availableTypes: [Service.ServiceType] = [.internalService, .externalService]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        
        fetchedResultController = model.fetchedResultController(availableTypes: availableTypes)
        fetchedResultController?.delegate = self
    }
    //MARK: Обработка событий
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDataUpdated), name: ServicesFacade.updatedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateError), name: ServicesFacade.errorNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNoNetworkUpdateError), name: ServicesFacade.noNetworkNotification, object: nil)
        
        try? fetchedResultController?.performFetch()
        
        model.updateServices()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func reload() {
        model.updateServices()
    }
    
    func onDataUpdated() {
        refreshControl?.endRefreshing()
        
        if model.hasServices(availableTypes: availableTypes) {
            showContentBackground()
        } else {
            showMessageBackground("Услуг нет", subtitle: "Потяните экран, чтобы обновить")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserServiceCell") as! ServiceCell
        let service = fetchedResultController!.object(at: indexPath)
        cell.show(service)
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
                let service = fetchedResultController!.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath) as! ServiceCell
                cell.show(service)
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
