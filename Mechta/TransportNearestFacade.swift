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
    
    //todo учитывать доступность рейса в будний/выходной
    //todo добавить расчет времени до начала рейса
    var nearest: [(startTime: String, endTime: String, left: String)] {
        guard let start = model.startBusStop else {
            return []
        }
        guard let end = model.endBusStop else {
            return []
        }
        
        let nearest = model.nearest(from: start, to: end)
        return nearest.map() { start, end in
            let startTime = start.stopTime ?? ""
            let endTime = end.stopTime ?? ""
            let leftTime = ""
            return (startTime, endTime, leftTime)
        }
    }
}
