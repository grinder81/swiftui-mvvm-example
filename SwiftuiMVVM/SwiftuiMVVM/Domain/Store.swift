import Foundation
import CoreLocation

struct Store: Codable, Identifiable, Equatable {
    let id: String
    let rating: Double
    let price: String?
    let name: String
    let imageUrl: URL
    let distance: Double
    let transactions: [String]
    let reviewCount: Int
    let categories: [Category]
    let coordinates: Coordinate

    enum CodingKeys: String, CodingKey {
        case id, rating, price, name, distance
        case transactions, categories, coordinates
        case imageUrl = "image_url"
        case reviewCount = "review_count"
    }

    struct Category: Codable, Equatable {
        let alias: String
        let title: String
    }

    struct Coordinate: Codable, Equatable {
        let latitude: Double
        let longitude: Double
    }
}
