import Foundation
import Combine

class RootViewModel: ObservableObject {
    @Published var selection: Tab = .home
}
