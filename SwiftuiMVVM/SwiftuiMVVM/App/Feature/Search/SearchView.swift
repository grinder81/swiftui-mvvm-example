import SwiftUI

// https://stackoverflow.com/questions/56490963/how-to-display-a-search-bar-with-swiftui


struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")

                        TextField(
                            "Search",
                            text: self.$viewModel.searchText,
                            onEditingChanged: { isEditing in
                                viewModel.isCancelEnabed = true
                            },
                            onCommit: {

                            }
                        )
                        .foregroundColor(.primary)

                        Button(
                            action: {
                                viewModel.searchText = ""
                            },
                            label: {
                                Image(systemName: "xmark.circle.fill")
                                    .opacity(viewModel.isCancelEnabed ? 1 : 0)
                            }
                        )
                    }
                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                    if viewModel.isCancelEnabed {
                        Button(
                            action: {
                                UIApplication.shared.endEditing(true) 
                                viewModel.searchText = ""
                                viewModel.isCancelEnabed = false
                            },
                            label: {
                                Text("Cancel")
                            }
                        )
                    }
                }
                .padding()

                List {
                    ForEach(viewModel.stores) { store in
                        Text(store.name)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle(Text("Search"))
            .navigationBarHidden(viewModel.isCancelEnabed)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: .init())
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}
