import Foundation
import Combine

extension URLSession {
    // URLSession for image with more memory and
    // disk cache
    static func imageSession() -> URLSession {
        let urlCache = URLCache(
            memoryCapacity: 100 * 1024 * 1024,
            diskCapacity:  200 * 1024 * 1024
        )
        let config = URLSessionConfiguration.default
        config.urlCache = urlCache
        config.requestCachePolicy = .returnCacheDataElseLoad

        return URLSession(configuration: config)
    }
}

struct ImageLoader {
    var fetchImage: (URL) -> AnyPublisher<Data?, Never>
}

extension ImageLoader {
    static func live(urlSession: URLSession = .shared) -> Self {
        Self(fetchImage: { url in
            urlSession.dataTaskPublisher(for: url)
                .map { data, _ in data }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        })
    }
}
