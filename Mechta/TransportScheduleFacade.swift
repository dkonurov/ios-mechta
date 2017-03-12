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
        
        let flights = model.busRouteFlights(from: start, to: end)
        guard flights.count > 0 else {
            return []
        }
        
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
                    //Если известно, что ранее добавленный рейс для этого времени доступен не только по выходным - удаляем старый вариант
                    if workingDaysOnly == false && items[i].minutes.contains(where: {min, workingDaysOnly in min == minute && workingDaysOnly == true}) {
                        if let index = items[i].minutes.index(where: {$0.0 == minute}) {
                            items[i].minutes.remove(at: index)
                        }
                    }
                    //Если рейса с такими минутами нет - добавляем его
                    if !items[i].minutes.contains(where: {$0.0 == minute}) {
                        items[i].minutes.append((minute, workingDaysOnly))
                    }
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
