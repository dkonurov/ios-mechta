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
    
    private let updateQueue = DispatchQueue(label: "BusRoutesModelUpdate")
    
    init(context: NSManagedObjectContext, busStopsModel: BusStopsModel) {
        self.mainContext = context
        self.busStopsModel = busStopsModel
    }
    
    func updateBusRoutesInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        busStopsModel.updateBusStopsInStorage(onError: onError) { [unowned self] in
            let networkContext = CoreDataManager.instance.concurrentContext()
            self.busRoutesFromNetwork(context: networkContext, onError: onError) {[unowned self] netBusRoutes in
                self.updateQueue.sync {
                    let storageContext = CoreDataManager.instance.concurrentContext()
                    let storedBusRoutes: [BusRoute] = CoreDataManager.instance.fetch("BusRoute", from: storageContext)
                    
                    //Удаляем элементы, которые удалены на сервере
                    for busRoute in storedBusRoutes {
                        if !netBusRoutes.contains(where: {$0 == busRoute}) {
                            storageContext.delete(busRoute)
                        }
                    }
                    
                    //Удаляем полученные элементы, которые уже есть в хранилище
                    for busRoute in netBusRoutes {
                        if storedBusRoutes.contains(where: {$0 == busRoute}) {
                            networkContext.delete(busRoute)
                        }
                    }
                    
                    //Сохраняем контекст
                    try? networkContext.saveIfNeeded()
                    try? storageContext.saveIfNeeded()
                    try? self.mainContext.saveIfNeeded()
                    
                    onSuccess()
                }
            }
        }
    }
    
    func busRoutesFromNetwork(context: NSManagedObjectContext, onError: @escaping (NetworkError) -> Void, onSuccess: @escaping ([BusRoute]) -> Void) {
        NetworkManager.get("/bus_routes", onError: onError) { json in
            let busRoutes = json.arrayValue.map() { BusRoute.from(json: $0, context: context) }
            onSuccess(busRoutes)
        }
    }
    
    func busRoutesFromStorage() -> [BusRoute] {
        return CoreDataManager.instance.fetch("BusRoute")
    }
}
