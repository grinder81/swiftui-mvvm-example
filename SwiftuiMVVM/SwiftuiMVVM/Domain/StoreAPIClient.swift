import Foundation
import Combine

// You can move to SPM will have huge compile time help

struct StoreAPIClient {
    var baseUrl: () -> URL
    var setBaseUrl: (URL) -> Void
    var searchStore: (StoreSearchRequest) -> AnyPublisher<StoreSearchResponse, Error>
}

extension StoreAPIClient {
    static func mock() -> Self {
        Self {
            fatalError()
        } setBaseUrl: { _ in
            fatalError()
        } searchStore: { _ in
            fatalError()
        }
    }
}
