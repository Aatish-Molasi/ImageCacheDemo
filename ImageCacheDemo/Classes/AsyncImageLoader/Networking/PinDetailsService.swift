import Foundation

typealias PinDetailsServiceSuccess =  (_ pinData: [String: Any]) -> Void
typealias PinDetailsServiceFailed = (_ failureMsg: String) -> Void

struct PinDetailsLoader {
    static func getPinDetails(success: @escaping PinDetailsServiceSuccess, failure: @escaping PinDetailsServiceFailed) {
    }
}
