import UIKit

class NewsPagingViewControoler: PagingViewControoler {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "News", bundle: Bundle.main)
        
        let postsController = storyboard.instantiateViewController(withIdentifier: "News")
        let offersController = storyboard.instantiateViewController(withIdentifier: "Offers")
        let excursionsController = storyboard.instantiateViewController(withIdentifier: "Excursions")
        
        showItems([("Новости", postsController), ("Акции", offersController), ("Экскурсии", excursionsController)])
    }
}
