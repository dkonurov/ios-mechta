import UIKit

extension UITableViewController {
    func showLoadingBackground() {
        tableView.showLoadingBackground()
    }
    
    func showMessageBackground(_ title: String?, subtitle: String?) {
        tableView.showMessageBackground(title, subtitle: subtitle)
    }
    
    func showContentBackground() {
        tableView.showContentBackground()
    }
    
    func showMessageAlert(_ message: String, completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: completion)
    }
}
