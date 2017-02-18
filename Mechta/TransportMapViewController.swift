import UIKit
import YandexMapView

class TransportMapViewController: UIViewController {
    @IBOutlet weak var mapView: YandexMapView!
    
    private let model = TransportMapFacade()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.onMapLoaded = onMapLoaded
        mapView.start()
    }
    
    func onMapLoaded() {
        updateData()
        model.onUpdate = updateData
    }
    
    func updateData() {
        for busStop in model.busStops {
            print(busStop.title!)
            print(busStop.latitude)
            print(busStop.longitude)
            mapView.showMarker(id: Int(busStop.id),
                               latitude: busStop.latitude,
                               longitude: busStop.longitude,
                               title: busStop.title ?? "Остановка")
        }
    }
}
