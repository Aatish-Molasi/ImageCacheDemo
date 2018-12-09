import Foundation

class User: Codable {
    let id: String
    let username: String
    let name: String
    let profileImage: [String: String]
    let links: [String: String]
}
