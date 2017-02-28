//
//  NearestTransportFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation
import SwiftDate

struct NearestTransportItem {
    let startTime: Date
    let endTime: Date
    let interval: TimeInterval
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
    
    var nearestItems: [NearestTransportItem] {
        guard let start = model.startBusStop else {
            return []
        }
        guard let end = model.endBusStop else {
            return []
        }
        
        let flights = model.busRouteFlights(from: start, to: end)
        guard flights.count > 0 else {
            return []
        }
        
        //Ищем информацию о начальных и конечных остановках для подходящих маршрутов
        var flightEnds = [(BusRouteFlightStop, BusRouteFlightStop)]()
        for flight in flights {
            let stops = flight.stops?.array as! [BusRouteFlightStop]
            let startStop = stops.first(where: { $0.busStop?.id == start.id })
            let endStop = stops.first(where: { $0.busStop?.id == end.id })
            
            if startStop != nil && endStop != nil {
                flightEnds.append((startStop!, endStop!))
            }
        }
        
        var nearestItems = [NearestTransportItem]()
        
        //Добавляем оставшиеся сегодняшние рейсы
        let now = Date()
        for (startStop, endStop) in flightEnds {
            let flight = startStop.flight!
            let startTime = Date.fromHm(startStop.stopTime!, day: now)!
            let endTime = Date.fromHm(endStop.stopTime!, day: now)!
            let availableDay = flight.weekendAvailability && now.isWeekend() || flight.workingDaysAvailability && now.isWorkingDay()
            let availableTime = now < startTime
            let interval = startTime.timeIntervalSince(now)
            if availableDay && availableTime {
                nearestItems.append(NearestTransportItem(startTime: startTime, endTime: endTime, interval: interval))
            }
        }
        
        //Добавляем рейсы, которые будут завтра
        let tomorrow = 1.days.fromNow()!
        for (startStop, endStop) in flightEnds {
            let flight = startStop.flight!
            let startTime = Date.fromHm(startStop.stopTime!, day: tomorrow)!
            let endTime = Date.fromHm(endStop.stopTime!, day: tomorrow)!
            let availableDay = flight.weekendAvailability && tomorrow.isWeekend() || flight.workingDaysAvailability && tomorrow.isWorkingDay()
            let interval = startTime.timeIntervalSince(tomorrow)
            if availableDay {
                nearestItems.append(NearestTransportItem(startTime: startTime, endTime: endTime, interval: interval))
            }
        }
        return nearestItems
    }
    
    //todo доделать
    func startAutoUpdate() {
        
    }
    
    //todo доделать
    func stopAutoUpdate() {
        
    }
}
