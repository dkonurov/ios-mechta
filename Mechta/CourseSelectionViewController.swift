import UIKit

class CourseSelectionViewController: UIViewController {
    
    @IBOutlet weak var swapDirectionsImageView: UIImageView!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onStartClick))
        startLabel.isUserInteractionEnabled = true
        startLabel.addGestureRecognizer(startTapRecognizer)
        
        let endTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onEndClick))
        endLabel.isUserInteractionEnabled = true
        endLabel.addGestureRecognizer(endTapRecognizer)
        
        let swapTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onSwapDirectionsClick))
        swapDirectionsImageView.isUserInteractionEnabled = true
        swapDirectionsImageView.addGestureRecognizer(swapTapRecognizer)
    }
    
    func showStartPoint() {
        
    }
    
    func showEndPoint() {
        
    }
    
    func onStartClick() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "BusStops") as? BusStopListViewController {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func onEndClick() {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "BusStops") as? BusStopListViewController {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func onSwapDirectionsClick() {
    }
}
