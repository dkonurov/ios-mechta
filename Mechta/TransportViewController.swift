import UIKit

class TransportViewController: UIViewController {
    private var nearestController: TransportNearestViewController?
    private var scheduleController: TransportScheduleViewController?
    private var mapController: TransportMapViewController?
    private var courseSelectionController: CourseSelectionViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Транспорт"
        
        let pagingController = childViewControllers.first(where: {$0 is TransportPagingViewController}) as? TransportPagingViewController
        nearestController = pagingController?.nearestController
        scheduleController = pagingController?.scheduleController
        mapController = pagingController?.mapController
        courseSelectionController = childViewControllers.first(where: {$0 is CourseSelectionViewController}) as? CourseSelectionViewController
    }
}
