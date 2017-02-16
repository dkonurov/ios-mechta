//
//  BusStopsModel.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 14.02.17.
//
//

import Foundation
import CoreData

class BusStopsModel {
    let mainContext: NSManagedObjectContext
    let networkManager = NetworkManager()
    
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
}
