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
    
    var nearestItems: [NearestTransportItem] {
        guard let start = model.startBusStop else {
            return []
        }
        guard let end = model.endBusStop else {
            return []
        }
        
        //TODO Унести в инициализацию приложения
        let moscow = Region(tz: TimeZoneName.europeMoscow, cal: CalendarName.gregorian, loc: LocaleName.russianRussia)
        Date.setDefaultRegion(moscow)
        
        let flightEnds = model.flightEnds(start: start, end: end)
        
        var nearestEnds = [(BusRouteFlightStop, BusRouteFlightStop)]()
        
        //Добавляем оставшиеся сегодняшние рейсы
        let now = Date()
        let todayEnds = flightEnds.filter() { start, _ in
            let flight = start.flight
            let availableDay = flight?.weekendAvailability == true && now.isWeekend() || flight?.workingDaysAvailability == true && now.isWorkingDay()
            
            let currentTime = now.hmValue()
            let availableTime = currentTime < start.stopTime!
            
            return availableDay && availableTime
        }
        nearestEnds.append(contentsOf: todayEnds)
        
        //Добавляем рейсы, которые будут завтра
        let tomorrow = 1.days.fromNow()!
        let tomorrowEnds = flightEnds.filter() { start, _ in
            let flight = start.flight
            return flight?.weekendAvailability == true && tomorrow.isWeekend() || flight?.workingDaysAvailability == true && tomorrow.isWorkingDay()
        }
        nearestEnds.append(contentsOf: tomorrowEnds)
        
        //Преобразуем в строки, вычисляем оставшееся время
        return nearestEnds.map() { start, end in
            let startTimeStr = start.stopTime!
            let endTimeStr = end.stopTime!            
            return NearestTransportItem(startTime: startTimeStr, endTime: endTimeStr)
        }
    }
    
    //todo доделать
    func startAutoUpdate() {
        
    }
    
    //todo доделать
    func stopAutoUpdate() {
        
    }
}
