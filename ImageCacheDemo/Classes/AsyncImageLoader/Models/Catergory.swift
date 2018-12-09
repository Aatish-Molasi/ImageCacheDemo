import Foundation

struct Category: Codable {
    let id: String
    let title: String
    let photoCount: Int
    let links: [String: String]
}

