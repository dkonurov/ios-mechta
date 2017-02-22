//
//  TransportMapFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation

class TransportMapFacade {
    var onUpdate: (() -> Void)?
    
    private let model: TransportModel
    
    init() {
        model = AppModel.instance.transportModel
        NotificationCenter.default.addObserver(self, selector: #selector(onRouteChanged), name: TransportModel.selectedRouteChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onRouteChanged), name: TransportModel.updatedNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onRouteChanged() {
        onUpdate?()
    }
    
    @objc func onRoutesUpdated() {
        onUpdate?()
    }
    
    var busStops: [BusStop] {
        guard let start = model.startBusStop else {
            return []
        }
        guard let end = model.endBusStop else {
            return []
        }
        guard let route = model.busRoute(from: start, to: end) else {
            return []
        }
        
        let flight = route.flights!.firstObject as! BusRouteFlight
        let flightStops = flight.stops!.array as! [BusRouteFlightStop]
        let startFlightStop = flightStops.first(where: { $0.busStop?.id == start.id })!
        let endFlightStop = flightStops.first(where: { $0.busStop?.id == end.id })!
        let startIndex = flightStops.index(of: startFlightStop)!
        let endIndex = flightStops.index(of: endFlightStop)!
        let stopsSlice = flightStops[startIndex...endIndex]
        return stopsSlice.map(){ $0.busStop! }
    }
}
