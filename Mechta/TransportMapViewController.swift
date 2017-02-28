import UIKit
import YandexMapView

class TransportMapViewController: UIViewController {
    @IBOutlet weak var mapView: YandexMapView!
    
    private let model = TransportMapFacade()
    private let presetBusStop = "islands#blueMassTransitCircleIcon"
    private let presetBusStopFirst = "islands#nightMassTransitCircleIcon"
    
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
                               title: busStop.title ?? "Остановка",
                               preset: busStop.id == busStops.first?.id ? presetBusStopFirst : presetBusStop)
        }
        
        if let startBusStop = busStops.first {
            mapView.setZoom(zoom: 16)
            mapView.setCenter(latitude: startBusStop.latitude, longitude: startBusStop.longitude)
        }
    }
}
