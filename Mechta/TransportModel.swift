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
}
