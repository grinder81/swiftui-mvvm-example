import SwiftUI

// https://stackoverflow.com/questions/56490963/how-to-display-a-search-bar-with-swiftui


struct SelectableCell: View {
    let item: String

    @Binding var selected: String

    var body: some View {
        HStack {
            Text(item)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            selected = item
        }
    }
}

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(
                    searchText: $viewModel.searchText,
                    isEditing: $viewModel.isCancelEnabed
                )
                .padding()

                Group {
                    // When we have result
                    if let stores  = viewModel.suggestedStores {
                        List {
                            ForEach(stores) { store in
                                Text(store.name)
                            }
                        }
                        .listStyle(PlainListStyle())
                    } else {
                        List {
                            if viewModel.defaultStores.recents.count > 0 {
                                Section(header: Text("Recents")) {
                                    ForEach(viewModel.defaultStores.recents, id: \.self) { recent in
                                        SelectableCell(
                                            item: recent,
                                            selected: $viewModel.selectedText
                                        )
                                    }
                                }
                                .textCase(nil)
                            }

                            Section(header: Text("Cuisines")) {
                                ForEach(viewModel.defaultStores.cusines, id: \.self) { cuisine in
                                    SelectableCell(
                                        item: cuisine.rawValue,
                                        selected: $viewModel.selectedText
                                    )
                                }

                            }
                            .textCase(nil)
                        }
                        .listStyle(PlainListStyle())
                    }
                }
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
