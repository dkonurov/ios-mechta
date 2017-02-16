//
//  NetworkManager.swift
//  Mechta
//
//  Created by Евгений Сафронов on 07.02.17.
//
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreData

enum NetworkError: Error {
    case offline
    case fault(Error)
}

class NetworkManager {
    private let updateQueue = DispatchQueue(label: "UpdateItemsQueue")
    
    func updateItemsInStorage<T: NSManagedObject>(
        serviceMethod: String,
        itemParser: @escaping (JSON, NSManagedObjectContext) -> T,
        entityName: String,
        comparator: @escaping (T, T) -> Bool,
        onError: @escaping (NetworkError) -> Void,
        onSuccess: @escaping () -> Void
        ) {
        
        let networkContext = CoreDataManager.instance.concurrentContext()
        get(serviceMethod, onError: onError) { json in
            self.updateQueue.sync {
                let netItems: [T] = json.arrayValue.map() { itemParser($0, networkContext) }
                
                let storageContext = CoreDataManager.instance.concurrentContext()
                let storedItems: [T] = CoreDataManager.instance.fetch(entityName, from: storageContext)
                
                //Удаляем элементы, которые удалены на сервере
                for item in storedItems {
                    if !netItems.contains(where: {comparator($0, item)}) {
                        storageContext.delete(item)
                    }
                }
                
                //Удаляем полученные элементы, которые уже есть в хранилище
                for item in netItems {
                    if storedItems.contains(where: {comparator($0, item)}) {
                        networkContext.delete(item)
                    }
                }
                
                //Сохраняем контекст
                try? networkContext.saveIfNeeded()
                try? storageContext.saveIfNeeded()
                try? CoreDataManager.instance.mainContext.saveIfNeeded()
                
                DispatchQueue.main.async {
                    onSuccess()
                }
            }
        }
    }
    
    func get(_ method: String, onError: @escaping (NetworkError) -> Void, onSuccess: @escaping (JSON) -> Void) {
        let address = Constants.serviceUrl + method
        
        if Constants.logingEnabled {
            print("\nvvvvvvvvvvvvvvvvvvvvvvvvvvv")
            print("Отправка запроса GET: \(address)")
        }
        
        Alamofire.request(address, method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseString { response in
                switch response.result {
                case .success(let str):
                    if Constants.logingEnabled {
                        print("Пришел ответ:\n\(str)")
                        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^\n")
                    }
                    
                    if let dataFromString = str.data(using: .utf8, allowLossyConversion: false) {
                        let json = JSON(data: dataFromString)
                        onSuccess(json)
                    }
                case .failure(let err):
                    if Constants.logingEnabled {
                        print("Ошибка:\n\(err)")
                        print("^^^^^^^^^^^^^^^^^^^^^^^^^^^\n")
                    }
                    
                    if let error = err as? URLError, error.code == URLError.notConnectedToInternet {
                        onError(.offline)
                    } else {
                        onError(.fault(err))
                    }
                }
        }
    }
}
