import SwiftUI

enum Tab: Int {
    case home
    case pickup
    case offers
    case search
    case orders
}

struct RootView: View {
    @ObservedObject var viewModel: RootViewModel

    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        TabView(selection: self.$viewModel.selection) {
            HomeView(viewModel: .init())
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(Tab.home)

            PickView(viewModel: .init())
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("Pickup")
                }
                .tag(Tab.pickup)


            OffersView()
                .tabItem {
                    Image(systemName: "tag")
                    Text("Offers")
                }
                .tag(Tab.offers)

            SearchView(viewModel: .init())
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(Tab.search)

            Text("Orders")
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("Orders")
                }
                .tag(Tab.orders)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: .init())
    }
}
