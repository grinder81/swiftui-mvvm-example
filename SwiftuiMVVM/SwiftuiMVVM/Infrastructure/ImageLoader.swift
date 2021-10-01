import Foundation
import Combine

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
