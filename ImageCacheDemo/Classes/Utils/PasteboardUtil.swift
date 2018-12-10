import Foundation

class PasteBoardUtil {
    class func getDateFromString(dateString: String?) -> Date? {
        guard dateString != nil else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = PasteBoardConstants.pinDateFormat
        let formattedDate = dateFormatter.date(from: dateString!)
        return formattedDate
    }
}
