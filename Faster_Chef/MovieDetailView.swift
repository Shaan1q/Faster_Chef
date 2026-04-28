
import SwiftUI

struct MovieDetailView: View {
    
    @Environment(NetworkClient.self) private var networkClient
    let movie: Movie
    
    var body: some View {
        ZStack{
            Color(red: 1, green: 0.75, blue: 0.8)
                .ignoresSafeArea()
            ScrollView(.vertical) {
                VStack(alignment: .center, spacing: 16) {
                    ScrollView(.vertical) {
                        VStack(alignment: .center, spacing: 16) {
                            
                            //title
                            Text(movie.title)
                                .multilineTextAlignment(.center)
                                .font(.system(.largeTitle, design: .monospaced, weight: .heavy))
                                .shadow(color: .red, radius: 1)
                                .bold()
                            
                            // poster
                            MovieImage(posterPath: movie.poster_path)
                            
                            Text(networkClient.selectedMovieDetails.tagline)
                                .multilineTextAlignment(.center) // if more than one line, center align all lines
                                .font(.system(.title2, design: .monospaced, weight: .medium))
                                .bold()
                            

                            if (networkClient.selectedMovieDetails.overview != " ") {
                                ZStack {
                                    let darkerBlue = Color(red: 0.322, green: 0.506, blue: 0.749, opacity: 1)
                                    let lighterBlue = Color(red: 0.518, green: 0.663, blue: 0.851, opacity: 1)
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(darkerBlue)
                                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(lighterBlue)
                                                .shadow(color: .black, radius: 3, x: 1, y: 1)
                                            Text("Overview")
                                                .font(.system(.title2, design: .monospaced, weight: .medium))
                                                .padding(2)
                                        }
                                        .padding(.bottom, 8)
                                        Text(networkClient.selectedMovieDetails.overview)
                                            .font(.system(.body, design: .monospaced, weight: .light))
                                            .layoutPriority(1) // required to ensure ZStack doesn't take up half
                                    }
                                    .padding()
                                }
                                .frame(maxWidth: 340)
                            }
                            
                            ZStack {
                                let lighterPurple = Color(red: 0.7059, green: 0.5725, blue: 0.8706, opacity: 1)
                                let darkerPurple = Color(red: 0.539, green: 0.39, blue: 0.669, opacity: 1)
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(darkerPurple)
                                    .shadow(color: .black, radius: 5, x: 2, y: 2)
                                VStack(spacing: 10) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(lighterPurple)
                                            .shadow(color: .black, radius: 3, x: 1, y: 1)
                                        Text("Facts & Figures")
                                            .font(.system(.title2, design: .monospaced, weight: .medium))
                                            .padding(2)
                                    }
                                    .padding(.bottom, 8)
                                    HStack {
                                        Text("Release Date")
                                            .font(.system(.body, design: .monospaced, weight: .bold))
                                        Spacer()
                                        Text("\(networkClient.selectedMovieDetails.release_date)")
                                            .font(.system(.body, design: .monospaced, weight: .light))
                                    }
                                    HStack {
                                        Text("Runtime")
                                            .font(.system(.body, design: .monospaced, weight: .bold))
                                        Spacer()
                                        Text("\(networkClient.selectedMovieDetails.runtime) minutes")
                                            .font(.system(.body, design: .monospaced, weight: .light))
                                    }
                                    HStack {
                                        Text("Revenue")
                                            .font(.system(.body, design: .monospaced, weight: .bold))
                                        Spacer()
                                        Text("$\(networkClient.selectedMovieDetails.revenue)")
                                            .font(.system(.body, design: .monospaced, weight: .light))
                                    }
                                    HStack {
                                        Text("Vote Average")
                                            .font(.system(.body, design: .monospaced, weight: .bold))
                                        Spacer()
                                        Text("\(networkClient.selectedMovieDetails.vote_average)")
                                            .font(.system(.body, design: .monospaced, weight: .light))
                                    }
                                    
                                }
                                .padding()
                            }
                            .frame(maxWidth: 340)
                            
                            // homepage section; only display if there is a homepage
                            if (networkClient.selectedMovieDetails.homepage != "") {
                                ZStack {
                                    let pink = Color(red: 0.87, green: 0.51, blue: 0.75, opacity: 1)
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(pink)
                                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                                    
                                    // use built-in Link type to automatically navigate to URL in Safari
                                    // (NOTE: only works on a simulator or device; does not open in Preview)
                                    Link("Visit Website", destination: URL(string: networkClient.selectedMovieDetails.homepage)!)
                                        .font(.system(.title2, design: .monospaced, weight: .medium))
                                        .padding()
                                        .foregroundStyle(.black)
                                }
                                .frame(maxWidth: 340)
                            }
                            
                        }
                        .padding()
                    }
                }
                .scrollIndicators(.hidden)
                .task {
                    await networkClient.getMovieDetails(movieID: movie.id)
                }
            }
        }
    }
    
    struct MovieImage : View {
        let posterPath : String?
        
        var body: some View {
            if let posterPathUnwrapped = posterPath {
                let imageURL = URL(string: "https://image.tmdb.org/t/p/w200\(posterPathUnwrapped)")
                AsyncImage(url: imageURL) { receivedImage in
                    receivedImage
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 500)
                .cornerRadius(15)
                .overlay {
                    let linGrad = LinearGradient(
                        gradient: Gradient(colors: [Color.pink, Color.blue, Color.purple]),
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(linGrad, lineWidth: 8)
                }
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 120, weight: .ultraLight))
                    .frame(width: 160, height: 190)
                    .background(.orange)
                    .cornerRadius(15)
            }
        }
        }
    }
    
    #Preview {
        MovieDetailView(movie: Movie(id: 1, title: "TEST", poster_path: "/imKSymKBK7o73sajciEmndJoVkR.jpg"))
            .environment(NetworkClient())
    }
