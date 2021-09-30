import Foundation
import Combine

class AppStore: ObservableObject {
    @Published var stores: [Store]?
}

extension AppStore {
    // This is the ONLY singleton I can allow in a project
    // That's the single source of truth
    static let store = AppStore()
}
