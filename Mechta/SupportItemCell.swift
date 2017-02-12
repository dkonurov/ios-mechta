import UIKit

class SupportItemCell: UITableViewCell {
    @IBOutlet var iconImageView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    
    func show(title: String, imageName: String) {
        titleLabel?.text = title
        iconImageView?.image = UIImage(named: imageName)
    }
}
