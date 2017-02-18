//
//  TransportScheduleFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation

class TransportScheduleFacade {
    var onUpdate: (() -> Void)?
    var onError: (() -> Void)?
    var onNoNetwork: (() -> Void)?
    
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
    
    var schedule: [(BusRouteFlightStop, BusRouteFlight)] {
        guard let start = model.startBusStop else {
            return []
        }
        guard let end = model.endBusStop else {
            return []
        }
        
        return model.schedule(from: start, to: end).map(){ ($0, $0.flight!) }
    }
    
    func updateSchedule() {
        model.updateBusRoutesInStorage(onError: onError, onSuccess: onUpdateSuccess)
    }
    
    func onError(error: NetworkError) {
        switch error {
        case .fault(_): onError?()
        case .offline: onNoNetwork?()
        }
    }
    
    func onUpdateSuccess() {
        onUpdate?()
    }
}
