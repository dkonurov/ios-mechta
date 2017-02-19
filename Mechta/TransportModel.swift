//
//  BusRoutesModel.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 15.02.17.
//
//

import Foundation
import CoreData

class TransportModel {
    static let updatedNotification = NSNotification.Name("TransportUpdated")
    static let selectedRouteChangedNotification = NSNotification.Name("TransportRouteChanged")
    
    let mainContext: NSManagedObjectContext
    
    var startBusStop: BusStop? {
        didSet {
            NotificationCenter.default.post(name: TransportModel.selectedRouteChangedNotification, object: nil)
            savePrefs()
        }
    }
    
    var endBusStop: BusStop? {
        didSet {
            NotificationCenter.default.post(name: TransportModel.selectedRouteChangedNotification, object: nil)
            savePrefs()
        }
    }
    
    private let networkManager = NetworkManager()
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
        loadPrefs()
    }
    
    func updateBusStopsInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        networkManager.updateItemsInStorage(
            serviceMethod: "/bus_stops",
            itemParser: BusStop.from,
            entityName: "BusStop",
            comparator: {$0 == $1},
            onError: onError,
            onSuccess: onSuccess)
    }
    
    func busStopsFromStorage() -> [BusStop] {
        return CoreDataManager.instance.fetch("BusStop")
    }
    
    func updateBusRoutesInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        updateBusStopsInStorage(onError: onError) { [unowned self] in
            self.networkManager.updateItemsInStorage(
                serviceMethod: "/bus_routes",
                itemParser: BusRoute.from,
                entityName: "BusRoute",
                comparator: {$0 == $1},
                onError: onError) {
                    NotificationCenter.default.post(name: TransportModel.updatedNotification, object: nil)
                    onSuccess()
            }
        }
    }
    
    func busRoutesFromStorage() -> [BusRoute] {
        return CoreDataManager.instance.fetch("BusRoute")
    }
    
    func busRoute(from start: BusStop, to end: BusStop) -> BusRoute? {
        let routes = busRoutesFromStorage()
        for route in routes where route.flights != nil {
            let flights = route.flights?.array as! [BusRouteFlight]
            for flight in flights where flight.stops != nil{
                let stops = flight.stops?.array as! [BusRouteFlightStop]
                if let startStop = stops.first(where: {$0.busStop?.id == start.id}) {
                    if let endStop = stops.first(where: {$0.busStop?.id == end.id}){
                        if stops.index(of: startStop)! < stops.index(of: endStop)! {
                            return route
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func busStops(from start: BusStop, to end: BusStop) -> [BusStop] {
        guard let route = busRoute(from: start, to: end) else {
            return []
        }
        let flights = route.flights?.array as! [BusRouteFlight]
        return stops(flight: flights.first!, from: start, to: end).map(){ $0.busStop! }
    }
    
    func busStops(flight: BusRouteFlight, from start: BusStop, to end: BusStop) -> [BusStop] {
        return stops(flight: flight, from: start, to: end).map(){ $0.busStop! }
    }
    
    func stops(flight: BusRouteFlight, from start: BusStop, to end: BusStop) -> [BusRouteFlightStop] {
        let stops = flight.stops?.array as! [BusRouteFlightStop]
        let startStop = stops.first(where: { $0.busStop?.id == start.id })!
        let endStop = stops.first(where: { $0.busStop?.id == end.id })!
        
        let startIndex = stops.index(of: startStop)!
        let endIndex = stops.index(of: endStop)!
        
        let stopsSlice = stops[startIndex...endIndex]
        return Array(stopsSlice)
    }
    
    func schedule(from start: BusStop, to end: BusStop) -> [BusRouteFlightStop] {
        guard let route = busRoute(from: start, to: end) else {
            return []
        }
        var schedule = [BusRouteFlightStop]()
        let flights = route.flights?.array as! [BusRouteFlight]
        for flight in flights {
            let stops = flight.stops?.array as! [BusRouteFlightStop]
            let matched = stops.filter({$0.busStop?.id == start.id})
            schedule.append(contentsOf: matched)
        }
        return schedule
    }
    
    func flightEnds(start: BusStop, end: BusStop) -> [(BusRouteFlightStop, BusRouteFlightStop)] {
        guard let route = busRoute(from: start, to: end) else {
            return []
        }
        
        var nearest = [(BusRouteFlightStop, BusRouteFlightStop)]()
        let flights = route.flights?.array as! [BusRouteFlight]
        
        for flight in flights {
            let stops = flight.stops?.array as! [BusRouteFlightStop]
            let startStop = stops.first(where: { $0.busStop?.id == start.id })
            let endStop = stops.first(where: { $0.busStop?.id == end.id })
            
            if startStop != nil && endStop != nil {
                nearest.append((startStop!, endStop!))
            }
        }
        
        return nearest
    }
    
    private func savePrefs() {
        let prefs = PreferencesStorage.load()
        prefs.startBusStopId = startBusStop?.id
        prefs.endBusStopId = endBusStop?.id
        prefs.save()
    }
    
    private func loadPrefs() {
        let prefs = PreferencesStorage.load()
        let context = CoreDataManager.instance.mainContext
        
        if let startId = prefs.startBusStopId {
            startBusStop = BusStop.fetch(id: startId, context: context)
        }
        
        if let endId = prefs.endBusStopId {
            endBusStop = BusStop.fetch(id: endId, context: context)
        }
    }
}




