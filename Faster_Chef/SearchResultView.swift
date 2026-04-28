
import SwiftUI

struct SearchResultsView: View {
    @Environment(NetworkClient.self) private var networkClient
    @State private var selectedMovie: Movie?
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ZStack {
            Color(.lightGray)
                .ignoresSafeArea()
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    ForEach(networkClient.searchResults) { movie in
                        MovieRowItem(movie: movie)
                            .onTapGesture {
                                selectedMovie = movie
                            }
                    }
                }
            }
            .sheet(item: $selectedMovie) { tappedMovie in
                MovieDetailView(movie: tappedMovie)
                    .presentationDetents([.medium, .large])
            }
        }
    }
}

#Preview {
    SearchResultsView()
        .environment(NetworkClient())
}
