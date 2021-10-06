import Combine
import CoreLocation

struct LocationClient {
    var authorizationStatus: () -> CLAuthorizationStatus
    var requestWhenInUseAuthorization: () -> Void
    var requestLocation: () -> Void
    var delegate: AnyPublisher<DelegateEvent, Never>

    enum DelegateEvent {
        case didChangeAuthorization(CLAuthorizationStatus)
        case didUpdateLocations([CLLocation])
        case didFailWithError(Error)
    }
}
