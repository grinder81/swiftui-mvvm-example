import SwiftUI

struct StoreItemView: View {
    @ObservedObject var viewModel: StoreItemViewModel

    init(viewModel: StoreItemViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            if let item = viewModel.item {
                ZStack {
                    VStack {
                        Image(uiImage: viewModel.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(4)
                        
                        HStack {
                            Image(systemName: "swift")
                                .foregroundColor(Color.green)

                            Text(item.name)
                                .bold()

                            Spacer()

                            Image(systemName: "heart")
                                .foregroundColor(Color.gray)
                        }
                        HStack {
                            Group {
                                if let price = item.price {
                                    Text(price)
                                        .foregroundColor(Color.gray)
                                }
                            }

                            Text(item.title)
                                .font(.footnote)
                                .foregroundColor(Color.gray)

                            Spacer()

                            Text("\(item.distanceInKm, specifier: "%0.1f") km")
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                        }
                        HStack(alignment: .bottom, spacing: 0) {
                            Text("\(item.rating, specifier: "%0.1f")")
                                .font(.footnote)
                                .foregroundColor(Color.gray)

                            Image(systemName: "star.fill")
                                .font(.footnote)
                                .foregroundColor(Color.gray)

                            Text("\(item.reviewCount) ratings")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .padding(.leading, 2)

                            Spacer()

                            Text(item.support)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 5)
                }
            } else {
                Text("Loading")
            }
        }
    }
}

struct StoreItemView_Previews: PreviewProvider {
    static var previews: some View {
        StoreItemView(viewModel: .init(id: ""))
    }
}
