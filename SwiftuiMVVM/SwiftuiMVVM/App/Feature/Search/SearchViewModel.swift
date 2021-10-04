import Foundation
import Combine

enum Cuisines: String, CaseIterable {
    case asian
    case breakfast
    case burgers
    case chicken
}

class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedText = ""
    @Published var isCancelEnabed = false
    @Published var suggestedStores: [Store]?
    @Published var defaultStores = SearchRecord()

    let storeSearchService: StoreSearchService

    var mergeCancellable: AnyCancellable?

    init(storeSearchService: StoreSearchService = .live(),
         location: String = "Toronto") {
        self.storeSearchService = storeSearchService

        // Build text field stream
        let searchStream = self.$searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)

        // Build selected text stream
        let selectedStream = self.$selectedText

        self.mergeCancellable = Publishers.Merge(searchStream, selectedStream)
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] term in
                if term.isEmpty == false &&
                    self?.defaultStores.recents.contains(term) == false {
                    self?.defaultStores.recents.append(term)
                }
                self?.searchText = term
            })
            .flatMap { term -> AnyPublisher<[Store]?, Never> in
                guard term.isEmpty == false else {
                    return Just(nil).eraseToAnyPublisher()
                }
                return storeSearchService.searchByTerm(term, location)
            }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink {[weak self] stores in
                self?.suggestedStores = stores
            }
    }
}

extension SearchViewModel {
    struct SearchRecord {
        var recents: [String] = []
        let cusines: [Cuisines] = Cuisines.allCases
    }
}
