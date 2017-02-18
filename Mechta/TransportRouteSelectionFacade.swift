//
//  CourseSelectionFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation

class RouteSelectionFacade {
    var onUpdate: (() -> Void)? 
    
    private let model: TransportModel
    
    init() {
        model = AppModel.instance.transportModel
        NotificationCenter.default.addObserver(self, selector: #selector(onRouteChanged), name: TransportModel.selectedRouteChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onRoutesUpdated), name: TransportModel.updatedNotification, object: nil)
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
    
    var startBusStop: BusStop? {
        set {
            model.startBusStop = newValue
        }
        get {
            return model.startBusStop
        }
    }
    
    var endBusStop: BusStop? {
        set {
            model.endBusStop = newValue
        }
        get {
            return model.endBusStop
        }
    }
}
