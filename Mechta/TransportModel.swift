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
    
    private let networkManager = NetworkManager()
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
        loadSelectedBusStops()
    }
    
    var startBusStop: BusStop? {
        didSet {
            NotificationCenter.default.post(name: TransportModel.selectedRouteChangedNotification, object: nil)
            saveSelectedBusStops()
        }
    }
    
    var endBusStop: BusStop? {
        didSet {
            NotificationCenter.default.post(name: TransportModel.selectedRouteChangedNotification, object: nil)
            saveSelectedBusStops()
        }
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
    
    func busRouteFlights(from start: BusStop, to end: BusStop) -> [BusRouteFlight] {
        var matchingFlights = [BusRouteFlight]()
        
        let routes = busRoutesFromStorage()
        for route in routes where route.flights != nil {
            let flights = route.flights?.array as! [BusRouteFlight]
            for flight in flights where flight.stops != nil{
                let stops = flight.stops?.array as! [BusRouteFlightStop]
                if let startStop = stops.first(where: {$0.busStop?.id == start.id}) {
                    if let endStop = stops.first(where: {$0.busStop?.id == end.id}){
                        if stops.index(of: startStop)! < stops.index(of: endStop)! {
                            matchingFlights.append(flight)
                        }
                    }
                }
            }
        }
        
        matchingFlights.sort() { f1, f2 in
            let stop1 = f1.stops!.first(where: {($0 as! BusRouteFlightStop).busStop!.id == start.id}) as! BusRouteFlightStop
            let stop2 = f2.stops!.first(where: {($0 as! BusRouteFlightStop).busStop!.id == start.id}) as! BusRouteFlightStop
            return stop1.stopTime! < stop2.stopTime!
        }
        return matchingFlights
    }
    
    private func saveSelectedBusStops() {
        let prefs = PreferencesStorage.load()
        prefs.startBusStopId = startBusStop?.id
        prefs.endBusStopId = endBusStop?.id
        prefs.save()
    }
    
    private func loadSelectedBusStops() {
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




