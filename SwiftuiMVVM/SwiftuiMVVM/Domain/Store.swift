import Foundation

struct Store: Codable, Identifiable, Equatable {
    let id: String
    let rating: Double
    let price: String?
    let name: String
    let imageUrl: URL

    enum CodingKeys: String, CodingKey {
        case id, rating, price, name
        case imageUrl = "image_url"
    }
}
