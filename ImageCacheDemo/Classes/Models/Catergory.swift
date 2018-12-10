import Foundation

struct Category: Codable {
    let id: String
    let title: String
    let photoCount: Int
    let links: [String: String]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case photoCount = "photo_count"
        case links
    }
}

