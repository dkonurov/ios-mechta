import UIKit

class OfferCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView?
    
    private weak var offer: Offer?
    
    func show(_ offer: Offer) {
        self.offer = offer
        
        titleLabel.text = offer.title
        descriptionLabel.text = offer.itemDescription
        detailsButton.isEnabled = offer.detailUrl != nil
        
        photoImageView?.load(
            offer.photoUrl,
            loadingPlaceholderName: "ImageLoadingPlaceholder",
            errorPlaceholderName: "ImageErrorPlaceholder"
        )
    }
    
    @IBAction func onDetailsButtonClick(_ sender: Any) {
        if offer != nil {
            OffersFacade().showDetailsPage(offer: offer!)
        }
    }
}
