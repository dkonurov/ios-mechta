import UIKit

extension UITableView {
    
    func showLoadingBackground() {
        tableFooterView?.isHidden = true
        tableHeaderView?.isHidden = true
        let loadingView = Bundle.main.loadNibNamed("TableViewBackgrounds", owner: self, options: nil)?[0] as! UIView
        loadingView.backgroundColor = UIColor.groupTableViewBackground
        backgroundView = loadingView
        backgroundView?.layer.zPosition = -20
        isUserInteractionEnabled = false;
    }
    
    func showMessageBackground(_ title: String?, subtitle: String?) {
        tableFooterView?.isHidden = true
        tableHeaderView?.isHidden = true
        let messageView = Bundle.main.loadNibNamed("TableViewBackgrounds", owner: self, options: nil)?[1] as! TableViewMessageBackgroundView
        messageView.backgroundColor = UIColor.groupTableViewBackground
        messageView.showMessage(title, subtitle: subtitle)
        backgroundView = messageView
        backgroundView?.layer.zPosition = -20
        isUserInteractionEnabled = true;
    }
    
    func showContentBackground() {
        tableFooterView?.isHidden = false
        tableHeaderView?.isHidden = false
        let background = UIView(frame: self.bounds)
        backgroundView = background
        backgroundView?.layer.zPosition = -20
        isUserInteractionEnabled = true
    }
}
