//
//  TransportMapFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation

class TransportMapFacade {
    static let courseChangedNotification = NSNotification.Name("TransportMapFacadeСourseChangedNotification")
    
    private let model: TransportModel
    
    init() {
        model = AppModel.instance.transportModel
        model.onRouteChanged = onRouteChanged
    }
    
    func onRouteChanged() {
        NotificationCenter.default.post(name: TransportMapFacade.courseChangedNotification, object: nil)
    }
}
