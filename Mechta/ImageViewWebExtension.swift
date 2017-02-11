import Foundation
import SDWebImage

extension UIImageView {
    
    func load(_ address: String?, loadingPlaceholderName: String, errorPlaceholderName: String ) {
        let placeholderError = UIImage(named: errorPlaceholderName)
        guard address != nil else {
            self.image = placeholderError
            return
        }
        
        let url = URL(string: address!)
        let placeholderLoading = UIImage(named: loadingPlaceholderName)
        
        SDWebImageDownloader.shared().setOperationClass(ImageDownloaderOperation.self)
        
        self.sd_setImage(with: url, placeholderImage: placeholderLoading, options: .allowInvalidSSLCertificates) { [weak self] image, error, cacheType, url in
            if error != nil {
                self?.image = placeholderError
            }
        }
    }
}

class ImageDownloaderOperation: SDWebImageDownloaderOperation {
    override func urlSession(_ session: Foundation.URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (Foundation.URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate) {
            completionHandler(.rejectProtectionSpace, nil)
        }
        if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(.useCredential, credential)
        }
    }
}
