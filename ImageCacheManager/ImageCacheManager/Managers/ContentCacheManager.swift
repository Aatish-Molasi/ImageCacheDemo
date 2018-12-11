import Foundation
import UIKit

internal struct DownloadedContent: Hashable {
    var hashValue: Int {
        return self.contentUrl.hashValue
    }
    
    static func ==(lhs: DownloadedContent, rhs: DownloadedContent) -> Bool {
        return lhs.contentUrl.hashValue == rhs.contentUrl.hashValue
    }
    
    var contentUrl: String
    var contentData: Data
    var contentRequestedCount: Int
    var lastRequestedTime: TimeInterval
    
    init(url: String, data: Data) {
        self.contentUrl = url
        self.contentData = data
        self.contentRequestedCount = 1
        self.lastRequestedTime = Date().timeIntervalSince1970
    }
}

internal class ContentCacheManager {
    internal var cachedContent:[String: DownloadedContent] = [:]
    internal var cacheSize = CacheConstants.defaultCacheSize
    static let sharedInstance: ContentCacheManager = { ContentCacheManager() }()

    func setCacheSize(cacheSize: Int) {
        self.cacheSize = cacheSize
    }

    func downloadedContent(content: Data, url:URL, cacheType: CacheType) {
        if cacheType == .memory {
            DispatchQueue.global(qos: .background).async {
                self.cachedContent[url.absoluteString] = DownloadedContent(url: url.absoluteString, data: content)
                if self.cachedContent.count > self.cacheSize {
                    self.removeAppropriateImage()
                }
            }
        }
    }
    
    func getContent(url: URL) -> Data? {
        return cachedContent[url.absoluteString]?.contentData
    }
    
    public func clearCache() {
        self.cachedContent.removeAll()
    }
    
    //We can change the logic to something more complex here and factor in things like frequency of use and size of asset among other things
    private func removeAppropriateImage() {
        DispatchQueue.global(qos: .background).async {
            if let lastUsed = self.cachedContent.values.max(by: {$0.lastRequestedTime > $1.lastRequestedTime}) {
                self.cachedContent = self.cachedContent.filter {
                    $0.value != lastUsed
                }
            }
        }
    }
}
