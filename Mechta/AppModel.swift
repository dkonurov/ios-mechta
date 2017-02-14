import Foundation
import UIKit
import CoreData

class AppModel {
    let excursionsModel: ExcursionsModel
    let newsModel: NewsModel
    let offersModel: OffersModel
    let servicesModel: ServicesModel
    let notificationsModel: NotificationsModel
    let busStopsModel: BusStopsModel
    
    let context = CoreDataManager.instance.mainContext
    
    init() {
        excursionsModel = ExcursionsModel(context: context)
        newsModel = NewsModel(context: context)
        offersModel = OffersModel(context: context)
        servicesModel = ServicesModel(context: context)
        notificationsModel = NotificationsModel(context: context)
        busStopsModel = BusStopsModel(context: context)
    }
    
    static var instance: AppModel {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.appModel!
    }
}
