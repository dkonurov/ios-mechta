import UIKit
import CoreData

class ServiceListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    private var model: ServicesFacade!
    private var fetchedResultController: NSFetchedResultsController<Service>?
    
    //Из меню настраиваем, какие типы будут доступны в списке
    var availableTypes: [Service.ServiceType] = [.internalService, .externalService]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        
        model = ServicesFacade(availableTypes: availableTypes)
        model.onNoNetwork = onNoNetworkUpdateError
        model.onUpdate = onDataUpdated
        model.onError = onUpdateError
        
        model.updateServices()
        
        fetchedResultController = model.fetchedResultController()
        fetchedResultController?.delegate = self
        try? fetchedResultController?.performFetch()
    }
    
    //MARK: Обработка событий
    
    func reload() {
        model.updateServices()
    }
    
    func onDataUpdated() {
        refreshControl?.endRefreshing()
        
        if model.hasServices {
            showContentBackground()
        } else {
            showMessageBackground("Услуг нет", subtitle: "Потяните экран, чтобы обновить")
        }
    }
    
    func onUpdateError() {
        if model.hasServices {
            showMessageAlert("Не удалось загрузить данные") { [weak self] in
                self?.refreshControl?.endRefreshing()
            }
        } else {
            refreshControl?.endRefreshing()
            showMessageBackground("Ошибка", subtitle: "Не удалось загрузить новости")
        }
    }
    
    func onNoNetworkUpdateError() {
        if model.hasServices {
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
        let service = fetchedResultController!.object(at: indexPath)
        let cellId = service.photoUrl != nil ? "ServiceCell" : "ServiceCellNoPhoto"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! ServiceCell
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
