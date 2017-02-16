//
//  NearestTransportFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation

class TransportNearestFacade {
    static let updatedNotification = NSNotification.Name("TransportNearestUpdatedNotification")
    
    private let model: TransportModel
    
    init() {
        model = AppModel.instance.transportModel
        model.onRouteChanged = onRouteChanged
    }
    
    func onRouteChanged() {
        NotificationCenter.default.post(name: TransportNearestFacade.updatedNotification, object: nil)
    }
}
