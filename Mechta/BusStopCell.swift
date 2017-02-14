import UIKit

class BusStopCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func show(busStop: BusStop) {
        titleLabel.text = busStop.title
    }
}
