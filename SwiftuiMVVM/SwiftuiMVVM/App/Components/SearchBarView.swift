import SwiftUI

extension UIApplication {
    func endEditing(force: Bool) {
        self.windows
            .filter { $0.isKeyWindow }
            .first?
            .endEditing(force)
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    @Binding var isEditing: Bool

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField(
                    "Search",
                    text: $searchText,
                    onEditingChanged: { editing in
                        print("\(editing)")
                        isEditing = true
                    },
                    onCommit: {}
                )
                .disableAutocorrection(true)
                .foregroundColor(.primary)

                Group {
                    if searchText.isEmpty == false {
                        Button(
                            action: {
                                searchText = ""
                            },
                            label: {
                                Image(systemName: "xmark.circle.fill")
                            }
                        )
                    }
                }
            }
            .padding(
                EdgeInsets(
                    top: 8,
                    leading: 6,
                    bottom: 8,
                    trailing: 6
                )
            )
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)

            Group {
                if isEditing {
                    Button(
                        action: {
                            UIApplication.shared.endEditing(force: true)
                            searchText = ""
                            isEditing = false
                        },
                        label: {
                            Text("Cancel")
                        }
                    )
                }
            }
        }
    }
}


struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(
            searchText: .constant("Hello"),
            isEditing: .constant(false)
        )
    }
}
