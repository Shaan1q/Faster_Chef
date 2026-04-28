import SwiftUI

struct ContentView: View {
    @Environment(NetworkClient.self) private var networkClient
    @State private var searchText = ""
    @State private var showSearchResults = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.lightGray)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        
                        Section {
                            RowView(apiEndpoint: .NowPlaying)
                        } header: {
                            Label {
                                Text("Now Playing:")
                                    .font(.system(.title, design: .rounded))
                                    .fontWeight(.heavy)
                            } icon: {
                                Circle()
                                    .fill(.green)
                                    .frame(width: 40, height: 40)
                                    .overlay {
                                        Image(systemName: "play")
                                            .font(.system(size: 24))
                                    }
                            }
                        }
                        
                        Section {
                            RowView(apiEndpoint: .Popular)
                        } header: {
                            Label {
                                Text("Popular:")
                                    .font(.system(.title, design: .rounded))
                                    .fontWeight(.heavy)
                            } icon: {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 40, height: 40)
                                    .overlay {
                                        Image(systemName: "flame")
                                            .font(.system(size: 24))
                                    }
                            }
                        }
                        Section {
                            RowView(apiEndpoint: .TopRated)
                        } header: {
                            Label {
                                Text("Top Rated:")
                                    .font(.system(.title, design: .rounded))
                                    .fontWeight(.heavy)
                            } icon: {
                                Circle()
                                    .fill(.yellow)
                                    .frame(width: 40, height: 40)
                                    .overlay {
                                        Image(systemName: "crown")
                                            .font(.system(size: 24))
                                    }
                            }
                        }
                        Section {
                            RowView(apiEndpoint: .Upcoming)
                        } header: {
                            Label {
                                Text("Upcoming:")
                                    .font(.system(.title, design: .rounded))
                                    .fontWeight(.heavy)
                            } icon: {
                                Circle()
                                    .fill(.cyan)
                                    .frame(width: 40, height: 40)
                                    .overlay {
                                        Image(systemName: "clock")
                                            .font(.system(size: 24))
                                    }
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .shadow(radius: 5)
            .navigationDestination(isPresented: $showSearchResults) {
                SearchResultsView()
            }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search, submitSearch)
    }
    
    private func submitSearch() {
        Task {
            await networkClient.searchMovies(query: searchText)
            showSearchResults = true
            searchText = ""
        }
    }
}

#Preview {
    ContentView()
        .environment(NetworkClient())
}
