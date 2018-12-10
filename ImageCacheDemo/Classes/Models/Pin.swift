import Foundation

struct Pin: Codable {
    let id: String
    let createdAt: Date?
    let width: Float
    let height: Float
    let color: String
    let likes: Double
    let likedByUser: Bool
    let user: User?
    let urls: [String: String]
    let catergories:[Category]?
    let links: [String: String]

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case width
        case height
        case color
        case likes
        case likedByUser = "liked_by_user"
        case user
        case urls
        case catergories
        case links
    }
}
