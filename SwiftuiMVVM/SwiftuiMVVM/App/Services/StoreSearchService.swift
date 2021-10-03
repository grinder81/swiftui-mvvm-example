import Foundation
import Combine
import CoreLocation

struct StoreSearchService {
    // Observe for stores data
    // Single source will provide that
    var stores: AnyPublisher<[Store], Never>

    // Initiate the call but VM doesn't need to know
    // the source. Single source will notify if any data
    // changes
    var searchByGeoLocation: (CLLocation) -> AnyCancellable

    // Search by text
    var searchByTerm: (String, String) -> AnyPublisher<[Store], Never>
}

extension StoreSearchService {
    // We can provide any testable data store for testing
    static func live(
        store: AppStore = .store,
        apiClient: StoreAPIClient = .live()
    ) -> Self {
        Self(
            stores: store.$stores
                .removeDuplicates()
                .replaceNil(with: [])
                .eraseToAnyPublisher(),
            searchByGeoLocation: { location in
                let request = StoreGeoSearchRequest(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                return apiClient.searchStore(request)
                    .sink(
                        receiveCompletion: { completion in
                            print("🧨 \(completion)")
                        },
                        receiveValue: { response in
                            store.stores = response.businesses
                        }
                    )
            },
            searchByTerm: { searchTerm, location in
                let request = StoreTermSearchRequest(
                    term: searchTerm,
                    location: location
                )
                return apiClient.searchStore(request)
                    .map { $0.businesses }
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
            }
        )
    }
}
