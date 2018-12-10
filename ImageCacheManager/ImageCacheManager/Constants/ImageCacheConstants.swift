import Foundation
import UIKit

public typealias DownloadCompletionBlock = (_ data: Data?, _ error: Error?, _ finished: Bool, _ url: URL, _ cacheType: CacheType) -> Void
//The only difference is this one gives us an image
public typealias ImageDownloadCompletionBlock = (_ image: UIImage?, _ error: Error?, _ finished: Bool, _ url: URL) -> Void

struct CacheConstants {
    static let defaultCacheSize = 10
}
