import UIKit

class ServicesPagingController: PagingViewControoler {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Services", bundle: Bundle.main)
        
        let allController = storyboard.instantiateViewController(withIdentifier: "Services") as! ServiceListViewController
        allController.availableTypes = [.externalService, .internalService]
        
        let internalController = storyboard.instantiateViewController(withIdentifier: "Services") as! ServiceListViewController
        internalController.availableTypes = [.internalService]
        
        let externalController = storyboard.instantiateViewController(withIdentifier: "Services") as! ServiceListViewController
        externalController.availableTypes = [.externalService,]
        
        showItems([("Все", allController), ("Жители", internalController), ("Организации", externalController)])
    }
}
