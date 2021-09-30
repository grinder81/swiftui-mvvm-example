import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            StoreListView()
                .navigationTitle("Store List")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
