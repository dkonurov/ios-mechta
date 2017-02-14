//
//  TransportFacade.swift
//  Mechta
//
//  Created by Evgeniy Safronov on 14.02.17.
//
//

import Foundation
import CoreData

class BusStopsFacade {
    
    static let updatedNotification = NSNotification.Name("BusStopsUpdated")
    static let errorNotification = NSNotification.Name("BusStopsError")
    static let noNetworkNotification = NSNotification.Name("BusStopsNoNetwork")
    
    private let model: BusStopsModel
    
    init() {
        self.model = AppModel.instance.busStopsModel
    }
    
    func fetchedResultController() -> NSFetchedResultsController<BusStop> {
        return CoreDataManager.instance.fetchedResultController(entityName: "BusStop", orderBy: "title")
    }
    
    var hasBusStops: Bool {
        return model.busStopsFromStorage().count > 0
    }
    
    func updateBusStops() {
        model.updateBusStopsInStorage(onError: onError, onSuccess: onUpdateSuccess)
    }
    
    func onError(error: NetworkError) {
        switch error {
        case .fault(_): NotificationCenter.default.post(name: BusStopsFacade.errorNotification, object: nil)
        case .offline: NotificationCenter.default.post(name: BusStopsFacade.noNetworkNotification, object: nil)
        }
    }
    
    func onUpdateSuccess() {
        NotificationCenter.default.post(name: BusStopsFacade.updatedNotification, object: nil)
    }
}
