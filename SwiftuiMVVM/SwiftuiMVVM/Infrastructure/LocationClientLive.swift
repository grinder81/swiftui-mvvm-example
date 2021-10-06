import Combine
import CoreLocation

extension LocationClient {
    static func live() -> Self {
        class Delegate: NSObject, CLLocationManagerDelegate {
            let subject: PassthroughSubject<DelegateEvent, Never>

            init(subject: PassthroughSubject<DelegateEvent, Never>) {
                self.subject = subject
                super.init()
            }

            func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
                subject.send(.didChangeAuthorization(manager.authorizationStatus))
            }

            func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                subject.send(.didUpdateLocations(locations))
            }

            func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                subject.send(.didFailWithError(error))
            }
        }

        let locationManager = CLLocationManager()
        let subject = PassthroughSubject<DelegateEvent, Never>()
        var delegate: Delegate? = Delegate(subject: subject)
        locationManager.delegate = delegate

        return Self(
            authorizationStatus: { locationManager.authorizationStatus },
            requestWhenInUseAuthorization: locationManager.requestWhenInUseAuthorization,
            requestLocation: locationManager.requestLocation,
            delegate: subject
                .handleEvents(receiveCancel: {
                    delegate = nil
                })
                .eraseToAnyPublisher()
        )
    }
}

