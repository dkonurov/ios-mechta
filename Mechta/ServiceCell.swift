import UIKit

class ServiceCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView?
    
    private weak var service: Service?
    
    private func show(_ service: Service) {
        self.service = service
        
        titleLabel.text = service.title
        descriptionLabel.text = service.itemDescription
        detailsButton.isEnabled = service.detailUrl != nil
        dateLabel.text = service.publishedAt?.dmyhmsValue()
        
        photoImageView?.load(
            service.photoUrl,
            loadingPlaceholderName: "ImageLoadingPlaceholder",
            errorPlaceholderName: "ImageErrorPlaceholder"
        )
    }
    
    @IBAction func onDetailsButtonClick(_ sender: Any) {
        if service != nil {
            ServicesFacade().showDetailsPage(service: service!)
        }
    }
}
