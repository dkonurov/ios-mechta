//
//  CourseSelectionFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation

class RouteSelectionFacade {
    static let updatedNotification = NSNotification.Name("CourseSelectionСourseChangedNotification")
    
    private let model: TransportModel
    
    init() {
        model = AppModel.instance.transportModel
        model.onRouteChanged = onRouteChanged
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
    
    func onRouteChanged() {
        NotificationCenter.default.post(name: RouteSelectionFacade.updatedNotification, object: nil)
    }
}
