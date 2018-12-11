import Foundation
import UIKit

public enum CacheType {
    case none
    case memory
}

public class DownloadManager: NSObject, URLSessionDelegate {
    internal var completionHandlers: [String: [DownloadRequest]] = [:]
    private let session:URLSession
    private let cacheManager: ContentCacheManager
    private let dataLoader: DataLoader

    static let sharedInstance: DownloadManager = {
        DownloadManager(cacheManager: ContentCacheManager.sharedInstance, session: URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.current), dataLoader: DataLoader())
    }()

    init(cacheManager: ContentCacheManager, session: URLSession, dataLoader: DataLoader) {
        self.cacheManager = cacheManager
        self.session = session
        self.dataLoader = dataLoader
        super.init()
    }

    private func downloadFromUrl(url : URL, cacheType: CacheType, manager: DownloadRequest) {
        self.downloadFromUrl(url: url, cacheType: cacheType, manager: manager, queue: DispatchQueue.global(qos: .userInitiated))
    }

    private func downloadFromUrl(url : URL, cacheType: CacheType, manager: DownloadRequest, queue: DispatchQueue) {
        var existingHandlers = self.completionHandlers[url.absoluteString] ?? []
        existingHandlers.append(manager)
        completionHandlers[url.absoluteString] = existingHandlers
        if let cachedContent = ContentCacheManager.sharedInstance.getContent(url: url) {
            let completionHandlersForUrl = completionHandlers[url.absoluteString] ?? []
            for handler in completionHandlersForUrl {
                handler.completionBlock?(cachedContent, nil, true, url, CacheType.memory)
                self.completionHandlers[url.absoluteString] = nil
            }
            return
        }
        let task = session.dataTask(with: url) {
            (data, response, error) in
            let completionHandlersForUrl = self.completionHandlers[url.absoluteString] ?? []
            guard let data = data else {
                for handler in completionHandlersForUrl {
                    handler.completionBlock?(nil, error, true, url.absoluteURL, cacheType)
                }
                self.completionHandlers[url.absoluteString] = nil
                return
            }

            queue.async {
                let downloadedData = data
                ContentCacheManager.sharedInstance.downloadedContent(content: downloadedData, url: url, cacheType: cacheType)
                for handler in completionHandlersForUrl {
                    handler.completionBlock?(downloadedData, nil, true, url.absoluteURL, CacheType.none)
                }
                self.completionHandlers[url.absoluteString] = nil
            }
        }
        task.resume()
    }

    func downloadFromUrl(url : URL, cacheType: CacheType, completed completedBlock: DownloadCompletionBlock?) -> DownloadRequest {
        return self.downloadFromUrl(url: url, cacheType: cacheType, queue: DispatchQueue.global(qos: .userInitiated), completed: completedBlock)
    }

    func downloadFromUrl(url : URL, cacheType: CacheType, queue: DispatchQueue, completed completedBlock: DownloadCompletionBlock?) -> DownloadRequest {
        let downloadManager = DownloadRequest(url: url, completionBlock: completedBlock, downloadManager: self)
        self.downloadFromUrl(url: url, cacheType: cacheType, manager: downloadManager, queue: queue)
        return downloadManager
    }

    func cancelDownload(url: URL, manager: DownloadRequest) {
        if var existingHandlers = self.completionHandlers[url.absoluteString],
            existingHandlers.count > 0 {
            existingHandlers = existingHandlers.filter {$0 != manager}
            if existingHandlers.count == 0 {
                completionHandlers[url.absoluteString] = nil
            } else {
                completionHandlers[url.absoluteString] = existingHandlers
            }
        }
    }

    func setMaxCacheCapacity(capacity: Int) {
        ContentCacheManager.sharedInstance.setCacheSize(cacheSize: capacity)
    }
}
