
import Foundation
import SwiftUI

@Observable
class NetworkClient{
    private var nowPlaying : [Movie] = []
    private var popular : [Movie] = []
    private var topRated : [Movie] = []
    private var upcoming : [Movie] = []
    private(set) var searchResults : [Movie] = []
    private var nowPlayingPage = 1
    private var popularPage = 1
    private var topRatedPage = 1
    private var upcomingPage = 1
    private(set) var selectedMovieDetails : MovieDetail = MovieDetail(overview: "asdf", homepage: "asdfas", release_date: "", revenue: 0, runtime: 0, tagline: "asdfasdf", vote_average: 0.0)
    
    func getMovieResults(endpoint: MovieAPIType) -> [Movie] {
        switch endpoint {
        case .NowPlaying:
            return nowPlaying
        case .Popular:
            return popular
        case .TopRated:
            return topRated
        case .Upcoming:
            return upcoming
        }
    }
    
    func getMovieData(endpoint: MovieAPIType) async {
        let pageNum: Int
        let endpointPath: String

        switch endpoint {
        case .NowPlaying:
            pageNum = nowPlayingPage
            endpointPath = "now_playing"
        case .Popular:
            pageNum = popularPage
            endpointPath = "popular"
        case .TopRated:
            pageNum = topRatedPage
            endpointPath = "top_rated"
        case .Upcoming:
            pageNum = upcomingPage
            endpointPath = "upcoming"
        }

        let urlStr = "https://api.themoviedb.org/3/movie/\(endpointPath)?api_key=e49014858fd78cc09bb2a956a28f6a4c&page=\(pageNum)"

        guard let url = URL(string: urlStr) else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MovieResponse.self, from: data)

            await MainActor.run {
                var movies = getMovieResults(endpoint: endpoint)

                for movie in response.results {
                    if !movies.contains(where: { $0.id == movie.id }) {
                        movies.append(movie)
                    }
                }

                switch endpoint {
                case .NowPlaying:
                    nowPlaying = movies
                    nowPlayingPage = response.page + 1
                case .Popular:
                    popular = movies
                    popularPage = response.page + 1
                case .TopRated:
                    topRated = movies
                    topRatedPage = response.page + 1
                case .Upcoming:
                    upcoming = movies
                    upcomingPage = response.page + 1
                }
            }

        } catch {
            print(error)
        }
    }
    
    func getMovieDetails(movieID: Int) async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=e49014858fd78cc09bb2a956a28f6a4c")
        guard let urlUnwrapped = url else {
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: urlUnwrapped)
            let movieDetails = try JSONDecoder().decode(MovieDetail.self, from: data)
            selectedMovieDetails = movieDetails
        } catch let error{
            print(error)
        }
    }
    
    func searchMovies(query: String) async {
        searchResults = []
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=e49014858fd78cc09bb2a956a28f6a4c&query=\(query)")
        guard let urlUnwrapped = url else { return }

        do {
            let (data, _) = try await URLSession.shared.data(from: urlUnwrapped)
            let response = try JSONDecoder().decode(MovieResponse.self, from: data)
            for movie in response.results {
                if !searchResults.contains(where: { $0.id == movie.id }) {
                    searchResults.append(movie)
                }
            }
        } catch let error {
            print(error)
        }
    }
}
