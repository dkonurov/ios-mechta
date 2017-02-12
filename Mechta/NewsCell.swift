import UIKit

class NewsCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView?
    @IBOutlet weak var continueReadingButton: UIButton!
    
    private weak var news: News?
    
    func show(_ news: News) {
        self.news = news
        
        titleLabel.text = news.title
        dateLabel.text = news.publishedAt?.dmyhmsValue()
        descriptionLabel.text = news.itemDescription
        continueReadingButton.isEnabled = news.detailUrl != nil
        
        photoImageView?.load(
            news.photoUrl,
            loadingPlaceholderName: "ImageLoadingPlaceholder",
            errorPlaceholderName: "ImageErrorPlaceholder"
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView?.image = nil
    }
    
    @IBAction func onContinueReadingButtonClick(_ sender: Any) {
        if news != nil {
            NewsFacade().showDetailsPage(news: news!)
        }
    }
}
