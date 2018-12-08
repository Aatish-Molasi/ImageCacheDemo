import Foundation

struct PasteBoardConstants {
    static let pinDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
}

struct PinAPIConstants {
    enum ImageTypes: String {
        case raw = "raw"
        case full = "full"
        case regular = "regular"
        case small = "small"
        case thumb = "thumb"
    }
}
