//
//  CourseSelectionFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation

class CourseSelectionFacade {
    static let courseChangedNotification = NSNotification.Name("CourseSelectionFacadeСourseChangedNotification")
    
    private let model: TransportModel
    
    init() {
        model = AppModel.instance.transportModel
        model.onRouteChanged = onRouteChanged
    }
    
    func setStartBusStop(_ busStop: BusStop) {
        model.startBusStop = busStop
    }
    
    func setEndBusStop(_ busStop: BusStop) {
        model.endBusStop = busStop
    }
    
    func onRouteChanged() {
        NotificationCenter.default.post(name: CourseSelectionFacade.courseChangedNotification, object: nil)
    }
}
