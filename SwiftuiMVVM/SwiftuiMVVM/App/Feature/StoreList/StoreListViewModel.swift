import Foundation
import Combine
import CoreLocation

struct StoreListService {
    // Observe for stores data
    // Single source will provide that
    var stores: AnyPublisher<[Store], Never>

    // Initiate the call but VM doesn't need to know
    // the source. Single source will notify if any data
    // changes
    var fetchStores: (CLLocation) -> AnyCancellable
}

extension StoreListService {
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
            fetchStores: { location in
                let request = StoreSearchRequest(
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

            }
        )
    }
}

class StoreListViewModel: ObservableObject {
    @Published var stores: [Store] = []

    let service: StoreListService

    var storesCancellable: AnyCancellable?
    var fetchStoreCancellable: AnyCancellable?

    init(service: StoreListService) {
        self.service = service

        // Register to observe
        // VM doesn't have any idea where the
        // data coming. It just observe and pass to View
        self.storesCancellable = self.service.stores
            .sink {[weak self] stores in
                self?.stores = stores
            }
    }

    func fetchStore() {
        // Hard coded co-ordinate for now
        // Use Core location service for real location
        self.fetchStoreCancellable = self.service
            .fetchStores(CLLocation(latitude: 43.651070, longitude: -79.347015))
    }
}

extension StoreListViewModel {
    static let live = StoreListViewModel(service: .live())
}
