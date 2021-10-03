import SwiftUI

struct StoreListView: View {
    @ObservedObject var viewModel: StoreListViewModel

    init(viewModel: StoreListViewModel = .live) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            ForEach(self.viewModel.stores) { store in
                StoreItemView(viewModel: .init(id: store.id))
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct StoreListView_Previews: PreviewProvider {
    static var previews: some View {
        StoreListView()
    }
}
