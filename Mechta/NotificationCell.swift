import UIKit

class NotificationCell: UITableViewCell {
    @IBOutlet weak var notificationTextLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var typeImageView: UIImageView?
    
    private func show(_ notification: Notification) {
        notificationTextLabel?.text = notification.text
        dateLabel?.text = notification.timeStamp?.dmyhmsValue()
        typeImageView?.image = UIImage(named: icon(forNotification: notification))
    }
    
    func icon(forNotification notification: Notification) -> String {
        switch notification.type {
        case .declinedBus: return "NotificationDeclinedBus"
        case .delayBus: return "NotificationRoadSituation"
        case .roadSituation: return "NotificationRoadSituation"
        case .adjustmentBus: return "NotificationRoadSituation"
        case .lastBus: return "NotificationLastBus"
        case .unknown: return ""
        }
    }
}
