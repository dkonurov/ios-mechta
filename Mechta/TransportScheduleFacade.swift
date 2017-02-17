//
//  TransportScheduleFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation

class TransportScheduleFacade {
    static let updatedNotification = NSNotification.Name("TransportScheduleUpdatedNotification")
    static let errorNotification = NSNotification.Name("TransportScheduleError")
    static let noNetworkNotification = NSNotification.Name("TransportScheduleNoNetwork")
    
    private let model: TransportModel
    
    init() {
        model = AppModel.instance.transportModel
        model.onRouteChanged = onRouteChanged
    }
    
    func onRouteChanged() {
        NotificationCenter.default.post(name: TransportScheduleFacade.updatedNotification, object: nil)
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
        case .fault(_): NotificationCenter.default.post(name: TransportScheduleFacade.errorNotification, object: nil)
        case .offline: NotificationCenter.default.post(name: TransportScheduleFacade.noNetworkNotification, object: nil)
        }
    }
    
    func onUpdateSuccess() {
        NotificationCenter.default.post(name: TransportScheduleFacade.updatedNotification, object: nil)
    }
}
