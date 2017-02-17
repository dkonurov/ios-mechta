import UIKit

class CourseSelectionViewController: UIViewController {
    
    @IBOutlet weak var swapDirectionsImageView: UIImageView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    private let model = RouteSelectionFacade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onStartClick))
        startLabel.isUserInteractionEnabled = true
        startLabel.addGestureRecognizer(startTapRecognizer)
        
        let endTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onEndClick))
        endLabel.isUserInteractionEnabled = true
        endLabel.addGestureRecognizer(endTapRecognizer)
        
        let swapTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(swapBusStops))
        swapDirectionsImageView.isUserInteractionEnabled = true
        swapDirectionsImageView.addGestureRecognizer(swapTapRecognizer)
    }
    
    func onStartClick() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "BusStops") as? BusStopListViewController {
            navigationController?.pushViewController(controller, animated: true)
            controller.title = "Начало пути"
            controller.onBusStopSelected = {
                [weak self] busStop in
                if self?.model.endBusStop == busStop {
                    self?.swapBusStops()
                } else {
                    self?.model.startBusStop = busStop
                }
                _ = self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func onEndClick() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "BusStops") as? BusStopListViewController {
            navigationController?.pushViewController(controller, animated: true)
            controller.title = "Конец пути"
            controller.onBusStopSelected = {
                [weak self] busStop in
                if self?.model.startBusStop == busStop {
                    self?.swapBusStops()
                } else {
                    self?.model.endBusStop = busStop
                }
                _ = self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func swapBusStops() {
        let startBusStop = model.startBusStop
        model.startBusStop = model.endBusStop
        model.endBusStop = startBusStop
    }
    
    //MARK: Обработка событий
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: RouteSelectionFacade.updatedNotification, object: nil)
        updateData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateData() {
        startLabel.text = model.startBusStop?.title ?? "Начало пути"
        endLabel.text = model.endBusStop?.title ?? "Конец пути"
    }
}
