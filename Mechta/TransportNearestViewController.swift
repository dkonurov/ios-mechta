import UIKit

class TransportNearestViewController: UITableViewController {
    private let model = TransportNearestFacade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.onNoNetwork = onNoNetworkUpdateError
        model.onUpdate = onDataUpdated
        model.onError = onUpdateError
        
        model.updateNearest()
    }
    
    func onDataUpdated() {
        refreshControl?.endRefreshing()
    }
    
    func onUpdateError() {
    }
    
    func onNoNetworkUpdateError() {
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
