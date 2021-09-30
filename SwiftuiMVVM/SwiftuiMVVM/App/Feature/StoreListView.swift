import SwiftUI

struct StoreListView: View {
    @ObservedObject var viewModel: StoreListViewModel

    init(viewModel: StoreListViewModel = .live) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            List {
                ForEach(self.viewModel.stores) { store in
                    Text(store.name)
                }
            }
            .listStyle(PlainListStyle())

            Button {
                self.viewModel.fetchStore()
            } label: {
                Image(systemName: "location.fill")
                    .foregroundColor(Color.white)
                    .frame(width: 60, height: 60)
            }
            .background(Color.black)
            .clipShape(Circle())
            .padding()
        }
        
    }
}

struct StoreListView_Previews: PreviewProvider {
    static var previews: some View {
        StoreListView()
    }
}
