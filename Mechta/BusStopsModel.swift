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
    
    private let updateQueue = DispatchQueue(label: "BusStopsModelUpdate")
    
    init(context: NSManagedObjectContext) {
        self.mainContext = context
    }
    
    func updateBusStopsInStorage(onError: @escaping (NetworkError) -> Void, onSuccess: @escaping () -> Void) {
        let networkContext = CoreDataManager.instance.concurrentContext()
        busStopsFromNetwork(context: networkContext, onError: onError) {[unowned self] netBusStops in
            self.updateQueue.sync {
                let storageContext = CoreDataManager.instance.concurrentContext()
                let storedBusStops: [BusStop] = CoreDataManager.instance.fetch("BusStop", from: storageContext)
                
                //Удаляем новости, которые удалены на сервере
                for busStop in storedBusStops {
                    if !netBusStops.contains(where: {$0.id == busStop.id}) {
                        storageContext.delete(busStop)
                    }
                }
                
                //Удаляем полученные элементы, которые уже есть в хранилище
                for busStop in netBusStops {
                    if storedBusStops.contains(where: {$0.id == busStop.id}) {
                        networkContext.delete(busStop)
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
    
    func busStopsFromNetwork(context: NSManagedObjectContext, onError: @escaping (NetworkError) -> Void, onSuccess: @escaping ([BusStop]) -> Void) {
        NetworkManager.get("/bus_stops", onError: onError) { json in
            let busStops = json.arrayValue.map() { BusStop.from(json: $0, context: context) }
            onSuccess(busStops)
        }
    }
    
    func busStopsFromStorage() -> [BusStop] {
        return CoreDataManager.instance.fetch("BusStop")
    }
}
