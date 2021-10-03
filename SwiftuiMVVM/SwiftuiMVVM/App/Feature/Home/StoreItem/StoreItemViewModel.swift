import Foundation
import Combine
import SwiftUI

struct StoreItemService {
    var store: (String) -> AnyPublisher<Store?, Never>
}

extension StoreItemService {
    static func live(store: AppStore = .store) -> Self {
        Self(store: { id in
            store.$stores
                // This could be expensive?? O(n)
                .map { $0?.first(where: { $0.id == id })}
                .eraseToAnyPublisher()
        })
    }
}

extension Store {
    var title: String {
        categories
            .map { $0.title }
            .joined(separator: ", ")
    }

    var distanceInKm: Double {
        distance / 1000.0
    }

    var support: String {
        transactions.joined(separator: ", ")
    }
}

class StoreItemViewModel: ObservableObject {
    @Published var item: Store?
    @Published var image = UIImage(systemName: "rays")!

    let id: String
    let service: StoreItemService
    let imageLoader: ImageLoader

    var storeCancellable: AnyCancellable?
    var imageCancellable: AnyCancellable?
    
    init(
        id: String,
        service: StoreItemService = .live(),
        imageLoader: ImageLoader = .live(urlSession: .imageSession())
    ) {
        self.id = id
        self.service = service
        self.imageLoader = imageLoader
        self.storeCancellable = self.service.store(id)
            .sink(
                receiveCompletion: { completion in
                    print("🧨 \(completion)")
                },
                receiveValue: { [weak self] store in
                    self?.item = store
                }
            )

        self.imageCancellable = self.$item
            .compactMap { $0 }
            .flatMap {[weak self] store -> AnyPublisher<Data?, Never> in
                guard let self = self else { return Just(nil).eraseToAnyPublisher() }
                return self.imageLoader.fetchImage(store.imageUrl)
            }
            .compactMap { $0 }
            .map { UIImage(data: $0) }
            .compactMap { $0 }
            .sink(receiveValue: {[weak self] image in
                self?.image = image
            })
    }
}

