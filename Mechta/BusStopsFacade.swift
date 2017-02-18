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
    var onUpdate: (() -> Void)?
    var onError: (() -> Void)?
    var onNoNetwork: (() -> Void)?
    
    private let model: TransportModel
    
    init() {
        self.model = AppModel.instance.transportModel
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
        case .fault(_): onError?()
        case .offline: onNoNetwork?()
        }
    }
    
    func onUpdateSuccess() {
        onUpdate?()
    }
}
