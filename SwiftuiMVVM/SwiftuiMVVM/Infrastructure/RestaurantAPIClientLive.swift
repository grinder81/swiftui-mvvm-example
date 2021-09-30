import Foundation
import Combine

// Core implementation

// Store in a secure place
private let API_KEY = "HFwlf0tcqyTjHiNDsWIlkzMXw8NccoJjWn--_dlPjdQYU4iy_1ajEwk26O2rpd6psyedU04SLgbmQMF2yi6aAC6moIRQmeVq5xnAStO3CIgm5i1FavfJw2iEJ3McYXYx"

struct StoreSearchRequest {
    let latitude: Double
    let longitude: Double
}

struct StoreSearchResponse: Codable {
    let total: Int
    let businesses: [Store]
}

extension StoreSearchRequest {
    func urlRequest(baseUrl: URL) -> URLRequest {
        guard let pathUrl = URL(string: "/v3/businesses/search", relativeTo: baseUrl) else {
            fatalError()
        }
        var components = URLComponents(url: pathUrl, resolvingAgainstBaseURL: true)
        components?.queryItems = [
            .init(name: "latitude", value: "\(latitude)"),
            .init(name: "longitude", value: "\(longitude)")
        ]
        guard let url = components?.url else {
            fatalError()
        }
        return URLRequest(url: url)
    }
}

extension StoreAPIClient {
    static func live(
        url: URL? = nil,
        urlSession: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) -> Self {
        var baseUrl = URL(string: "https://api.yelp.com")!
        if let url = url {
            baseUrl = url
        }
        return Self(
            baseUrl: {
                baseUrl
            },
            setBaseUrl: { url in
                baseUrl = url
            },
            searchStore: { request in
                let request = request
                    .urlRequest(baseUrl: baseUrl)
                    .urlRequest(apiKey: API_KEY)
                return urlSession
                    .dataTaskPublisher(for: request)
                    .map { data, _ in data }
                    .decode(type: StoreSearchResponse.self, decoder: decoder)
                    .receive(on: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
        )
    }
}

extension URLRequest {
    func urlRequest(apiKey: String) -> Self {
        var request = self
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        return request
    }
}
