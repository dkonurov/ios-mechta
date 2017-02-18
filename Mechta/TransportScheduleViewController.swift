import UIKit

class TransportScheduleViewController: UITableViewController {
    var items = [ScheduleItem]()
    
    private let model = TransportScheduleFacade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        
        model.onNoNetwork = onNoNetworkUpdateError
        model.onUpdate = onDataUpdated
        model.onError = onUpdateError
        
        model.updateSchedule()
    }
    
    //MARK: Обработка событий
    
    func reload() {
        model.updateSchedule()
    }
    
    func onDataUpdated() {
        refreshControl?.endRefreshing()
        items = model.scheduleItems
        
        if items.count > 0 {
            showContentBackground()
        } else {
            showMessageBackground("Автобусов для выбранного маршрута нет", subtitle: "Потяните экран, чтобы обновить")
        }
        
        tableView.reloadData()
    }
    
    func onUpdateError() {
        if items.count > 0 {
            showMessageAlert("Не удалось загрузить данные") { [weak self] in
                self?.refreshControl?.endRefreshing()
            }
        } else {
            refreshControl?.endRefreshing()
            showMessageBackground("Ошибка", subtitle: "Не удалось загрузить новости")
        }
    }
    
    func onNoNetworkUpdateError() {
        if items.count > 0 {
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! TransportScheduleCell
        let item = items[indexPath.row]
        cell.show(scheduleItem: item)
        return cell
    }
}
