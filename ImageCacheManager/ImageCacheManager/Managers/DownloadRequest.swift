import Foundation
import UIKit

internal class DownloadRequest: NSObject, URLSessionDelegate {
    var completionBlock: DownloadCompletionBlock?
    var currentUrl: URL?
    let downloadManager: DownloadManager
    
    init(url: URL,
         completionBlock: DownloadCompletionBlock?,
         downloadManager: DownloadManager = DownloadManager.sharedInstance) {
        self.currentUrl = url
        self.completionBlock = completionBlock
        self.downloadManager = downloadManager
        super.init()
    }
    
    func cancelCurrentDownload() {
        if let url = currentUrl {
            self.downloadManager.cancelDownload(url: url, manager: self)
        }
    }
}
