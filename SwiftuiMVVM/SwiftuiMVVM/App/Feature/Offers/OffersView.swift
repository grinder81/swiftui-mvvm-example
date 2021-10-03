import SwiftUI

struct OffersView: View {

    var body: some View {
        Text("Hello")
    }

}

struct OffersView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OffersView()
                .environment(\.colorScheme, .light)

            OffersView()
                .environment(\.colorScheme, .dark)
        }
    }
}
