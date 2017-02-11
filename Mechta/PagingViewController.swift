import UIKit
import PagingMenuController

private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    private let titles: [String]
    private let viewControllers: [UIViewController]
    
    init(storyboard: UIStoryboard, items: [(String, UIViewController)]) {
        titles = items.map() { (title, _) in title }
        viewControllers = items.map() { (_, controller) in controller }
    }
    
    var backgroundColor: UIColor {
        return Style.backgroundColor
    }
    
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(titles: titles), pagingControllers: pagingControllers)
    }
    
    fileprivate var pagingControllers: [UIViewController] {
        return viewControllers
    }
    
    fileprivate struct MenuOptions: MenuViewCustomizable {
        fileprivate let titles: [String]
        
        var displayMode: MenuDisplayMode {
            return .standard(widthMode: .flexible, centerItem: true, scrollingMode: .scrollEnabled)
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return titles.map() {ItemView(title: $0)}
        }
        var height: CGFloat {
            return 40
        }
        var focusMode: MenuFocusMode {
            return .none
        }
        
        fileprivate struct ItemView: MenuItemViewCustomizable {
            let title: String
            
            var displayMode: MenuItemDisplayMode {
                return .text(title: MenuItemText(text: title, color: Style.darkColor, selectedColor: Style.brightColor))
            }
        }
    }
}

class PagingViewControoler: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //Нужно, чтобы constraints расчитывались от navigationBar
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func showItems(_ items: [(String, UIViewController)]) {
        //Добавляем пейджинг
        let options = PagingMenuOptions(storyboard: storyboard!, items: items)
        let pagingMenuController = PagingMenuController(options: options)
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        
        //Настраиваем размер. Обязательно с помощью constraints
        let pagingBottom = NSLayoutConstraint(item: pagingMenuController.view,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 0)
        
        let pagingTop = NSLayoutConstraint(item: pagingMenuController.view,
                                           attribute: .top,
                                           relatedBy: .equal,
                                           toItem: view,
                                           attribute: .top,
                                           multiplier: 1,
                                           constant: 0)
        
        let pagingLeading = NSLayoutConstraint(item: pagingMenuController.view,
                                               attribute: .leading,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .leading,
                                               multiplier: 1,
                                               constant: 0)
        let pagingTrailing = NSLayoutConstraint(item: pagingMenuController.view,
                                                attribute: .trailing,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .trailing,
                                                multiplier: 1,
                                                constant: 0)
        view.addConstraints([pagingBottom, pagingTop, pagingLeading, pagingTrailing])
        
        
        //Добавляем треугольник
        let pageIndicatorImageView = UIImageView(image: UIImage(named:"PageIndicator"))
        view.addSubview(pageIndicatorImageView)
        
        let indicatorTop = NSLayoutConstraint(item: pageIndicatorImageView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: -2)
        
        let indicatorCenter = NSLayoutConstraint(item: pageIndicatorImageView,
                                                 attribute: .centerX,
                                                 relatedBy: .equal,
                                                 toItem: view,
                                                 attribute: .centerX,
                                                 multiplier: 1,
                                                 constant: 0)
        
        let indicatorWidth = NSLayoutConstraint(item: pageIndicatorImageView,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: 16)
        
        let indicatorHeight = NSLayoutConstraint(item: pageIndicatorImageView,
                                                 attribute: .height,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: 8)
        
        //Отключаем автогенерацию констрейнтов и добавляем свои
        pageIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        pageIndicatorImageView.addConstraints([indicatorWidth, indicatorHeight])
        view.addConstraints([indicatorTop, indicatorCenter])
        
        //Убираем тень, чтобы над треугольником не было белой полосы
        navigationController?.navigationBar.clipsToBounds = true
        
        pagingMenuController.didMove(toParentViewController: self)
    }
}
