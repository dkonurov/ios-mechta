import Foundation
import RESideMenu

class SideMenuCoordinatorViewController: RESideMenu {
    override func awakeFromNib() {
        let navigationController = storyboard?.instantiateViewController(withIdentifier: "NavigationController") as! SideMenuItemsViewController
        navigationController.coordinatorController = self
        leftMenuViewController = navigationController
        contentViewController = storyboard?.instantiateViewController(withIdentifier: "ContentController")
        
        scaleMenuView = false
        contentViewShadowEnabled = true
        menuPrefersStatusBarHidden = true
        parallaxEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let storyboard = UIStoryboard(name: "News", bundle: Bundle.main)
        showViewController(storyboard.instantiateInitialViewController()!)
    }
    
    func showViewController(_ controller: UIViewController) {
        let navigationController = contentViewController as! UINavigationController
        navigationController.setViewControllers([controller], animated: false)
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Sidebar"),
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(showMenuItems))
        hideViewController()
    }
    
    func showMenuItems() {
        presentLeftMenuViewController()
    }
}
