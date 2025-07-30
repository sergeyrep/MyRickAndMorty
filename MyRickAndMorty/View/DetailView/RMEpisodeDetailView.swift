import SwiftUI

struct RMEpisodeDetailView: View {
  @StateObject private var episodeDetailVM: EpisodeDetailViewModel
  
  init(episode: RMEpisode) {
    _episodeDetailVM = StateObject(wrappedValue: EpisodeDetailViewModel(detailEpisode: episode,
                                                                        networkService: RMNetworkService()))
  }
  
  var body: some View {
    ScrollView {
      DetailInfoRow(label: "Name: ", value: episodeDetailVM.detailEpisode.name)
      DetailInfoRow(label: "Episode: ", value: episodeDetailVM.detailEpisode.episode)
      DetailInfoRow(label: "Date: ", value: episodeDetailVM.detailEpisode.airDate ?? "")
      Text("Characters: \(episodeDetailVM.characters.count)")
      
      if !episodeDetailVM.characters.isEmpty {
        sectionCharacters
      } else if episodeDetailVM.isLoading {
        ProgressView()
      } else if let error = episodeDetailVM.error {
        Text("Error: \(error)")
      }
      
    }.task {
      await episodeDetailVM.fetchEpisodeDetails()
    }
  }
  
  private var sectionCharacters: some View {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 8) {
      ForEach(episodeDetailVM.characters) { character in
        NavigationLink {
          RMCharacterDetailView(viewModel: character)
        } label: {
          CharacterCard(character: character)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
  }
}
  
  
