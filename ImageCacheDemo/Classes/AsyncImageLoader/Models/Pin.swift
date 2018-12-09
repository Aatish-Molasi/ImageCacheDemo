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
}
