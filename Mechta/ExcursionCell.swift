import UIKit

class ExcursionCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView?
    
    private weak var excursion: Excursion?
    
    func show(_ excursion: Excursion) {
        self.excursion = excursion
        
        titleLabel.text = excursion.title
        descriptionLabel.text = excursion.itemDescription
        dateLabel.text = excursion.startDate?.dmyhmValue()
        continueButton.isEnabled = excursion.detailUrl != nil
        
        photoImageView?.load(
            excursion.photoUrl,
            loadingPlaceholderName: "ImageLoadingPlaceholder",
            errorPlaceholderName: "ImageErrorPlaceholder"
        )
    }
    
    @IBAction func onContinueButtonClick(_ sender: Any) {
        if excursion != nil {
            ExcursionsFacade().showDetailsPage(excursion: excursion!)
        }
    }
}
