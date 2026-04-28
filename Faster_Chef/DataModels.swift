import Foundation

struct MovieResponse: Codable{
    var page : Int
    var results: [Movie]
}

struct Movie: Identifiable, Codable{
    let id : Int
    let title: String
    let poster_path : String?
}

struct MovieDetail: Codable{
    var overview : String
    var homepage: String
    var release_date : String
    var revenue : Int
    var runtime: Int
    var tagline : String
    var vote_average : Double
}

enum MovieAPIType{
    case NowPlaying
    case Popular
    case TopRated
    case Upcoming
}
