import Foundation
import Combine
import MapKit

class PickupViewModel: ObservableObject {
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()

    let locationClient: LocationClient

    var locationCancellable: AnyCancellable?

    init(locationClient: LocationClient = .live()) {
        self.locationClient = locationClient

        self.locationCancellable = self.locationClient.delegate
            .sink {[weak self] event in
                switch event {
                case .didChangeAuthorization(let status):
                    switch status {
                    case .notDetermined:
                        break

                    case .restricted:
                        break

                    case .denied:
                        break

                    case .authorizedAlways, .authorizedWhenInUse:
                        self?.locationClient.requestLocation()

                    @unknown default:
                        fatalError()
                    }

                case .didUpdateLocations(let locations):
                    guard let location = locations.first else {
                        return
                    }
                    print(location)
                    self?.region = MKCoordinateRegion(
                        center: location.coordinate,
                        latitudinalMeters: 1000,
                        longitudinalMeters: 1000
                    )

                case .didFailWithError(let error):
                    print(error)
                }
            }
    }

    func fetchLocation() {
        switch locationClient.authorizationStatus() {
        case .notDetermined:
            locationClient.requestWhenInUseAuthorization()

        case .restricted:
            break

        case .denied:
            break

        case .authorizedAlways, .authorizedWhenInUse:
            locationClient.requestLocation()

        @unknown default:
            fatalError()
        }
    }
}
