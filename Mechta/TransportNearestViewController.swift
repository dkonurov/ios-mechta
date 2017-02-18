import UIKit

class TransportNearestViewController: UITableViewController {
    var items = [NearestTransportItem]()
    
    private let model = TransportNearestFacade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
        
        model.onNoNetwork = onNoNetworkUpdateError
        model.onUpdate = onDataUpdated
        model.onError = onUpdateError
        
        model.updateNearest()
    }
    
    //MARK: Обработка событий
    
    func reload() {
        model.updateNearest()
    }
    
    func onDataUpdated() {
        refreshControl?.endRefreshing()
        items = model.nearestItems
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearestCell") as! TransportNearestCell
        let item = items[indexPath.row]
        cell.show(item)
        return cell
    }
}
