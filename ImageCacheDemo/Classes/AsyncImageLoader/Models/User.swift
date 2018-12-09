import Foundation

class User: Codable {
    let id: String
    let username: String
    let name: String
    let profileImage: [String: String]
    let links: [String: String]

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case profileImage = "profile_image"
        case links
    }
}
