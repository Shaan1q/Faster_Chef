import SwiftUI

struct MovieRowItem : View {
    let movie: Movie
    
    var body: some View{
        VStack(spacing: 10){
            if let posterPath = movie.poster_path {
                let imageURL = URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)")
                AsyncImage(url: imageURL) { receivedImage in
                    receivedImage
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 127, height: 190)
                .cornerRadius(15)
                .overlay {
                    let linGrad = LinearGradient(
                        gradient: Gradient(colors: [Color.red, Color.orange, Color.cyan]),
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(linGrad, lineWidth: 4)
                }
            } else {
                Image(systemName: "photo")
                    .font(.system(size: 96, weight: .ultraLight))
                    .frame(width: 127, height: 190)
                    .background(.orange)
                    .cornerRadius(15)
            }

            Text(movie.title)
                .lineLimit(1)
                .font(.system(.body, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.yellow)
        }
        .frame(width: 160)
        .shadow(color: .black, radius: 5, x: 5, y: 5)
    }

}

#Preview{
    MovieRowItem(movie: Movie(id: 1, title: "movie title", poster_path: "/imKSymKBK7o73sajciEmndJoVkR.jpg"))
}
