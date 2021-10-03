import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var isCancelEnabed = false
    @Published var stores: [Store] = []

    var searchTextCancellable: AnyCancellable?

    let storeSearchService: StoreSearchService

    init(storeSearchService: StoreSearchService = .live(),
         location: String = "Toronto") {
        self.storeSearchService = storeSearchService
        self.searchTextCancellable = self.$searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .flatMap { term -> AnyPublisher<[Store], Never> in
                guard term.isEmpty == false else {
                    return Just([]).eraseToAnyPublisher()
                }
                return storeSearchService.searchByTerm(term, location)
            }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink {[weak self] stores in
                self?.stores = stores
            }
    }
}
