import Foundation

class PinManager {
    static let sharedManager = PinManager(urlSession: URLSession.shared)
    let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func getPins(page: Int, completion: @escaping ([Pin]?, Error?)->()) {
        if let url = URL(string:"http://pastebin.com/raw/wgkJgazE") {
            let task = self.urlSession.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Fetch operation failed with error : \(String(describing: error))")
                    completion(nil, error)
                }
                do {
                    if let safeData = data {
                        let result = try  JSONDecoder().decode([Pin].self, from: safeData)
                        completion(result, nil)
                    }
                }
                catch {
                    print(error)
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
}
