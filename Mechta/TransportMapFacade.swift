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
        
        return model.busStops(from: start, to: end)
    }
}
