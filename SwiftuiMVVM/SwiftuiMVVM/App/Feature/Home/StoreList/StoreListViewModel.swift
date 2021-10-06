import Foundation
import Combine
import CoreLocation

class StoreListViewModel: ObservableObject {
    @Published var stores: [Store] = []

    let service: StoreSearchService

    var storesCancellable: AnyCancellable?
    var fetchStoreCancellable: AnyCancellable?
    var locationCancellable: AnyCancellable?

    init(service: StoreSearchService) {
        self.service = service

        // Register to observe
        // VM doesn't have any idea where the
        // data coming. It just observe and pass to View
        self.storesCancellable = self.service.stores
            .sink {[weak self] stores in
                self?.stores = stores
            }

        self.locationCancellable = self.service.location
            .sink { [weak self] location in
                self?.fetchStoreCancellable = self?.service
                    .searchByGeoLocation(location)
        }
    }
}

extension StoreListViewModel {
    static let live = StoreListViewModel(service: .live())
}
