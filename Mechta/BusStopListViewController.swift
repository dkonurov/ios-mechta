import UIKit
import CoreData

class BusStopListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var onBusStopSelected: ((BusStop) -> Void)?
    
    private let model = BusStopsFacade()
    private var fetchedResultController: NSFetchedResultsController<BusStop>?
    
    //MARK: Инициализация
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 48
        
        refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        
        fetchedResultController = model.fetchedResultController()
        fetchedResultController?.delegate = self
    }
    
    //MARK: Обработка событий
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onDataUpdated), name: BusStopsFacade.updatedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateError), name: BusStopsFacade.errorNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onNoNetworkUpdateError), name: BusStopsFacade.noNetworkNotification, object: nil)
        
        try? fetchedResultController?.performFetch()
        
        model.updateBusStops()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func reload() {
        model.updateBusStops()
    }
    
    func onDataUpdated() {
        refreshControl?.endRefreshing()
        
        if model.hasBusStops {
            showContentBackground()
        } else {
            showMessageBackground("Информации об остановках нет", subtitle: "Потяните экран, чтобы обновить")
        }
    }
    
    func onUpdateError() {
        if model.hasBusStops {
            showMessageAlert("Не удалось загрузить данные") { [weak self] in
                self?.refreshControl?.endRefreshing()
            }
        } else {
            refreshControl?.endRefreshing()
            showMessageBackground("Ошибка", subtitle: "Не удалось загрузить новости")
        }
    }
    
    func onNoNetworkUpdateError() {
        if model.hasBusStops {
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
        let busStop = fetchedResultController!.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusStopCell") as! BusStopCell
        cell.show(busStop: busStop)
        return cell
    }
    
    //MARK: Выбор элемента
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let busStop = fetchedResultController!.object(at: indexPath)
        onBusStopSelected?(busStop)
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
                let busStop = fetchedResultController!.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath) as! BusStopCell
                cell.show(busStop: busStop)
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
