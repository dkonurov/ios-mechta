import UIKit

class MenuItemCell: UITableViewCell {
    @IBOutlet var iconImageView: UIImageView?
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet var selectionView: UIView?
    
    var menuItem: MenuItem? {
        didSet {
            showData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionView?.layer.cornerRadius = 3;
        selectionView?.layer.masksToBounds = true;
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        selectionView?.isHidden = !selected
    }

    func showData() {
        guard menuItem != nil else {
            return
        }
        
        iconImageView?.image = UIImage(named: menuItem!.iconName)
        titleLabel?.text = menuItem?.title
        selectionView?.isHidden = true
    }
}
