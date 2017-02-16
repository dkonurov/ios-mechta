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
    var onRouteChanged: (() -> Void)?
    
    let mainContext: NSManagedObjectContext
    
    var startBusStop: BusStop? {
        didSet {
            onRouteChanged?()
        }
    }
    
    var endBusStop: BusStop? {
        didSet {
            onRouteChanged?()
        }
    }
    
    private let networkManager = NetworkManager()
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
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
                onError: onError,
                onSuccess: onSuccess)
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
    
    func busStops(flight: BusRouteFlight, from start: BusStop, to end: BusStop) -> [BusStop] {
        let stops = flight.stops?.array as! [BusRouteFlightStop]
        let startStop = stops.first(where: { $0.busStop?.id == start.id })!
        let endStop = stops.first(where: { $0.busStop?.id == end.id })!
        
        let startIndex = stops.index(of: startStop)!
        let endIndex = stops.index(of: endStop)!
        
        let stopsSlice = stops[startIndex...endIndex]
        return Array(stopsSlice).map(){ $0.busStop! }
    }
}
