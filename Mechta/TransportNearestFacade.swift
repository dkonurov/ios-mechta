//
//  NearestTransportFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation

class TransportNearestFacade {
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
    
    //todo доделать
    func startAutoUpdate() {
        
    }
    
    //todo доделать
    func stopAutoUpdate() {
        
    }
}
