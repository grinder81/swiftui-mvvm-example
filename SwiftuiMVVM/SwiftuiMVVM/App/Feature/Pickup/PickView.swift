import SwiftUI
import MapKit

struct PickView: View {
    @ObservedObject var viewModel: PickupViewModel

    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
        }
        .onAppear {
            viewModel.fetchLocation()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        PickView(viewModel: .init())
    }
}


extension Binding {
    func debug() -> Self {
        print(wrappedValue)
        return self
    }
}
