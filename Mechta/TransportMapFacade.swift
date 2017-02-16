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
    }
    
    func onRouteChanged() {
        NotificationCenter.default.post(name: TransportMapFacade.updatedNotification, object: nil)
    }
}
