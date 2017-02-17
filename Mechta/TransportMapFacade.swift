//
//  TransportMapFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation

class TransportMapFacade {
    static let updatedNotification = NSNotification.Name("TransportMapUpdatedNotification")
    
    private let model: TransportModel
    
    init() {
        model = AppModel.instance.transportModel
        model.onRouteChanged = onRouteChanged
        model.onRoutesUpdated = onRoutesUpdated
    }
    
    func onRouteChanged() {
        NotificationCenter.default.post(name: TransportMapFacade.updatedNotification, object: nil)
    }
    
    func onRoutesUpdated() {
        NotificationCenter.default.post(name: TransportMapFacade.updatedNotification, object: nil)
    }
    
    var busStops: [BusStop] {
        guard let start = model.startBusStop else {
            return []
        }
        guard let end = model.endBusStop else {
            return []
        }
        
        return model.busStops(from: start, to: end)
    }
}
