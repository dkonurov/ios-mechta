import UIKit

class SideMenuItemsViewController: UITableViewController {
    weak var coordinatorController: SideMenuCoordinatorViewController?
    
    private var items = [MenuItem]()
    private var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items.append(MenuItem(title: "Новости", iconName: "MenuNews", storyboard: "News", startId: "NewsPaging"))
        items.append(MenuItem(title: "Услуги", iconName: "MenuServices", storyboard: "Services", startId: "ServicesPaging"))
        items.append(MenuItem(title: "Транспорт", iconName: "MenuTransport", storyboard: "Transport", startId: "Transport"))
        items.append(MenuItem(title: "Уведомления", iconName: "MenuNotifications", storyboard: "Notifications", startId: "Notifications"))
//        items.append(MenuItem(title: "Настройки", iconName: "MenuSettings", storyboard: "Settings", startId: "Settings"))
        items.append(MenuItem(title: "Связь с диспетчером", iconName: "MenuSupport", storyboard: "Support", startId: "Support"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuItemCell
        cell.menuItem = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let item = items[indexPath.row]
        let storyboard = UIStoryboard.init(name: item.storyboard, bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: item.startId)
        coordinatorController?.showViewController(controller)
    }
}
