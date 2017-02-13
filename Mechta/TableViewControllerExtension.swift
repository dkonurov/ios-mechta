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
    
    func showMessageAlert(_ message: String, completion:  (() -> Void)? = nil) {
//        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: completion)
//        }
    }
}
