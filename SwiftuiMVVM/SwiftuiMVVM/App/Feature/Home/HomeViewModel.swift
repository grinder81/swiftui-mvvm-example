import SwiftUI
import Combine
import CoreLocation

struct HomeService {
    var setLocation: (CLLocation) -> Void
}

extension HomeService {
    static func live(store: AppStore = .store) -> Self {
        Self(setLocation: { location in
            store.currentLocation = location
        })
    }
}


class HomeViewModel: ObservableObject {
    let service: HomeService
    let locationClient: LocationClient

    var delegateCancellable: AnyCancellable?

    init(
        service: HomeService = .live(),
        locationClient: LocationClient = .live()
    ) {
        self.service = service
        self.locationClient = locationClient
        self .delegateCancellable = self.locationClient.delegate
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
                        break
                    }
                case .didUpdateLocations(let locations):
                    guard let location = locations.first else {
                        return
                    }
                    self?.service.setLocation(location)
                    
                case .didFailWithError(let error):
                    print(error)
                    break
                }
        }
        fetchLocation()
    }

    func fetchLocation() {
        switch locationClient.authorizationStatus() {
        case .notDetermined:
            locationClient.requestWhenInUseAuthorization()

        case .restricted:
            // TODO: show alert
            break
        case .denied:
            // TODO: show alert
            break

        case .authorizedAlways, .authorizedWhenInUse:
            locationClient.requestLocation()

        @unknown default:
            fatalError()
        }
    }
}
