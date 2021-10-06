import Foundation
import Combine
import CoreLocation

class AppStore: ObservableObject {
    @Published var stores: [Store]?
    @Published var currentLocation: CLLocation?
}

extension AppStore {
    // This is the ONLY singleton I can allow in a project
    // That's the single source of truth
    static let store = AppStore()
}
