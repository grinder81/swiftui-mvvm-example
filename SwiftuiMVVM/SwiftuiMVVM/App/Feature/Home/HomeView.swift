import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                StoreListView()
            }
            .navigationBarTitle("Stores", displayMode: .inline)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
        }
    }
}
