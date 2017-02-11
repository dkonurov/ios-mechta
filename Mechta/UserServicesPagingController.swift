import UIKit

class UserServicesPagingController: PagingViewControoler {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "UserServices", bundle: Bundle.main)
        
        let allController = storyboard.instantiateViewController(withIdentifier: "Services") as! UserServiceListViewController
        allController.availableTypes = [.externalService, .internalService]
        
        let internalController = storyboard.instantiateViewController(withIdentifier: "Services") as! UserServiceListViewController
        internalController.availableTypes = [.internalService]
        
        let externalController = storyboard.instantiateViewController(withIdentifier: "Services") as! UserServiceListViewController
        externalController.availableTypes = [.externalService,]
        
        showItems([("Все", allController), ("Жители", internalController), ("Организации", externalController)])
    }
}
