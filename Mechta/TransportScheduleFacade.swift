//
//  TransportScheduleFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 16.02.17.
//
//

import Foundation

struct ScheduleItem {
    var hour: String
    var minutes: [(minute: String, workingDaysOnly: Bool)]
}

class TransportScheduleFacade {
    var onUpdate: (() -> Void)?
    var onError: (() -> Void)?
    var onNoNetwork: (() -> Void)?
    
    private let model: TransportModel
    
    init() {
        model = AppModel.instance.transportModel
        NotificationCenter.default.addObserver(self, selector: #selector(onRouteChanged), name: TransportModel.selectedRouteChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onRouteChanged), name: TransportModel.updatedNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onRouteChanged() {
        onUpdate?()
    }
    
    var schedule: [(BusRouteFlightStop, BusRouteFlight)] {
        guard let start = model.startBusStop else {
            return []
        }
        guard let end = model.endBusStop else {
            return []
        }
        guard let route = model.busRoute(from: start, to: end) else {
            return []
        }
        
        let flights = route.flights?.array as! [BusRouteFlight]
        
        var schedule = [BusRouteFlightStop]()
        for flight in flights {
            let stops = flight.stops?.array as! [BusRouteFlightStop]
            let matched = stops.filter({$0.busStop?.id == start.id})
            schedule.append(contentsOf: matched)
        }
        
        return schedule.map(){ ($0, $0.flight!) }
    }
    
    var scheduleItems: [ScheduleItem] {
        let schedule = self.schedule
        
        var items = [ScheduleItem]()
        for (stop, _) in schedule {
            if let time = stop.stopTime {
                let hour = time.components(separatedBy: ":")[0]
                let minute = time.components(separatedBy: ":")[1]
                let workingDaysOnly = stop.flight?.weekendAvailability == false
                
                if let i = items.index(where: {$0.hour == hour}) {
                    items[i].minutes.append((minute, workingDaysOnly))
                } else {
                    items.append(ScheduleItem(hour: hour, minutes: [(minute, workingDaysOnly)]))
                }
            }
        }
        
        return items
    }
    
    func updateSchedule() {
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
}
