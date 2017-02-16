//
//  BusRoutesModel.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 15.02.17.
//
//

import Foundation
import CoreData

class BusRoutesModel {
    let mainContext: NSManagedObjectContext
    let busStopsModel: BusStopsModel
    let networkManager = NetworkManager()
    
    init(context: NSManagedObjectContext, busStopsModel: BusStopsModel) {
        self.mainContext = context
        self.busStopsModel = busStopsModel
    }
    
    func updateBusRoutesInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        busStopsModel.updateBusStopsInStorage(onError: onError) { [unowned self] in
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
