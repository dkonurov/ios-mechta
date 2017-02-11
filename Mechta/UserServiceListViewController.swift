import UIKit

class UserServiceListViewController: UITableViewController {
    
    //Из меню настраиваем, какие типы будут доступны в списке
    var availableTypes: [Service.ServiceType] = [.internalService, .externalService]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)
    }
    
    func reload() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserServiceCell") as! ServiceCell
        return cell
    }
}
