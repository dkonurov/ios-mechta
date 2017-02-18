//
//  NearestTransportFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation

struct NearestTransportItem {
    let startTime: String
    let endTime: String
}

class TransportNearestFacade {
    var onUpdate: (() -> Void)?
    var onError: (() -> Void)?
    var onNoNetwork: (() -> Void)?
    
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
    
    func updateNearest() {
        model.updateBusRoutesInStorage(onError: onError, onSuccess: onUpdateSuccess)
    }
    
    func onError(error: NetworkError) {
        switch error {
        case .fault(_): onError?()
        case .offline: onNoNetwork?()
        }
    }
    
    func onUpdateSuccess() {
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
    
    var nearestItems: [NearestTransportItem] {
        return [
            NearestTransportItem(startTime: "10:00", endTime: "11:00"),
            NearestTransportItem(startTime: "10:30", endTime: "11:30"),
            NearestTransportItem(startTime: "11:50", endTime: "12:50"),
        ]
    }
    
    //todo доделать
    func startAutoUpdate() {
        
    }
    
    //todo доделать
    func stopAutoUpdate() {
        
    }
}
