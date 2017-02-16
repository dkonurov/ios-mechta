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
    
    private let model: TransportModel
    
    init() {
        model = AppModel.instance.transportModel
        model.onRouteChanged = onRouteChanged
    }
    
    func onRouteChanged() {
        NotificationCenter.default.post(name: TransportScheduleFacade.updatedNotification, object: nil)
    }
}
