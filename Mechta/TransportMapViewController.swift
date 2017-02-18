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
        mapView.clear()
        let busStops = model.busStops
        for busStop in busStops {
            mapView.showMarker(id: Int(busStop.id),
                               latitude: busStop.latitude,
                               longitude: busStop.longitude,
                               title: busStop.title ?? "Остановка")
        }
        if busStops.count > 0 {
            mapView.setZoom(zoom: 15)
            mapView.setCenter(latitude: busStops[0].latitude, longitude: busStops[0].longitude)
        }
    }
}
