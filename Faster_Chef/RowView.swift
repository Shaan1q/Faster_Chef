import SwiftUI

struct RowView: View {
    @Environment(NetworkClient.self) private var networkClient
    @State private var selectedMovie : Movie?
    let apiEndpoint : MovieAPIType
    
    var body: some View {
        ScrollView(.horizontal){
            LazyHStack(spacing: 4){
                ForEach(networkClient.getMovieResults(endpoint: apiEndpoint)){ movie in
                    MovieRowItem(movie: movie)
                        .onTapGesture {
                            selectedMovie = movie
                        }
                }
                if (networkClient.getMovieResults(endpoint: apiEndpoint).count > 0) {
                    Color.clear
                        .frame(width: 0, height: 0)
                        .task {
                            await networkClient.getMovieData(endpoint: apiEndpoint)
                        }
                }
            }
            .frame(height: 250)
        }
        .scrollIndicators(.hidden)
        .background(.gray)
        .sheet(item: $selectedMovie){ tappedMovie in
            MovieDetailView(movie: tappedMovie)
                .presentationDetents([.medium, .large])
        }
        .task{
            await networkClient.getMovieData(endpoint: apiEndpoint)
        }
    }
}

#Preview {
    RowView(apiEndpoint: .NowPlaying)
        .environment(NetworkClient())
}
