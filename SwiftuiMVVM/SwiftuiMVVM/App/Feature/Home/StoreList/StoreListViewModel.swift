import Foundation
import Combine
import CoreLocation

class StoreListViewModel: ObservableObject {
    @Published var stores: [Store] = []

    let service: StoreSearchService

    var storesCancellable: AnyCancellable?
    var fetchStoreCancellable: AnyCancellable?

    init(service: StoreSearchService) {
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
            .searchByGeoLocation(CLLocation(latitude: 43.651070, longitude: -79.347015))
    }
}

extension StoreListViewModel {
    static let live = StoreListViewModel(service: .live())
}
