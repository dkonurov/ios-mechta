import UIKit

class TransportPagingViewController: PagingViewControoler {
    var nearestController: TransportNearestViewController?
    var scheduleController: TransportScheduleViewController?
    var mapController: TransportMapViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Transport", bundle: Bundle.main)
        
        nearestController = storyboard.instantiateViewController(withIdentifier: "Nearest") as? TransportNearestViewController
        scheduleController = storyboard.instantiateViewController(withIdentifier: "Schedule") as? TransportScheduleViewController
        mapController = storyboard.instantiateViewController(withIdentifier: "Map") as? TransportMapViewController
        
        showItems([("Ближайший", nearestController!), ("Расписание", scheduleController!), ("Карта", mapController!)])
    }
}

