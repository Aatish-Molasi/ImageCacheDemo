import Foundation
import UIKit

struct AssociatedKeys {
    static var downloadManagerKey: UInt8 = 0
}

public extension UIImageView {
    internal var currentDownload:DownloadRequest? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.downloadManagerKey) as? DownloadRequest else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.downloadManagerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func setImage(wtihUrl url: URL?) {
        self.setImage(withURL: url, placeholderImage: nil, completed: nil)
    }
    func setImage(withURL url: URL?, placeholderImage placeholder: UIImage?, completed completionBlock: ImageDownloadCompletionBlock?) {
        self.setImage(withURL: url, placeholderImage: placeholder, cacheType: .memory, completed: completionBlock)
    }

    func setImage(withURL url: URL?, placeholderImage placeholder: UIImage?, cacheType: CacheType, completed completionBlock: ImageDownloadCompletionBlock?) {
        self.image = placeholder
        self.cancelDownload()
        var completionImage: UIImage? = nil
        if let url = url {
            self.currentDownload = DownloadManager.sharedInstance.downloadFromUrl(url: url, cacheType: cacheType, completed:{ [weak self]
                (data, error, finished, url, cacheType) -> Void in
                if let data = data {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            completionImage = image
                                self?.image = image
                        }
                        else {
                            self?.image = placeholder
                        }
                    }
                }
                completionBlock?(completionImage, error, true, url)
            })
        }
    }

    func transitionToImage(image: UIImage) {
        UIView.transition(with: self,
                        duration: 0.25,//It's an arbitrary number
                        options: .transitionCrossDissolve,
                        animations: {
                            self.image = image
                        },
                        completion: nil)

    }

    func cancelDownload() {
        self.currentDownload?.cancelCurrentDownload()
    }
}
