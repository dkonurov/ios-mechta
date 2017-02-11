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
    static func get(_ method: String, onError: @escaping (NetworkError) -> Void, onSuccess: @escaping (JSON) -> Void) {
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
