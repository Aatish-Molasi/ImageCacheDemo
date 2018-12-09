import Foundation

class PinManager {
    static let sharedManager = PinManager()

    func getPins(completion: @escaping ([Pin]?, Error?)->()) {
        if let url = URL(string:"http://pastebin.com/raw/wgkJgazE") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print("Fetch operation failed with error : \(String(describing: error))")
                    completion(nil, error)
                }
                print("This is the data : \(String(describing: data))")
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
