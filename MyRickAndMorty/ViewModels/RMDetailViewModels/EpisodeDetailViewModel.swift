import SwiftUI

@MainActor
final class EpisodeDetailViewModel: ObservableObject {
  @Published var detailEpisode: RMEpisode
  @Published var isLoading = false
  @Published var error: String?
  @Published var characters: [RMCharacter] = []
  
  private let networkService: RMNetworkService
  
  init(
    detailEpisode: RMEpisode,
    networkService: RMNetworkService
  ) {
    self.detailEpisode = detailEpisode
    self.networkService = networkService
  }
  
  func fetchEpisodeDetails() async {
    isLoading = true
    characters.removeAll()
    error = nil
    
    do {
      let charactersIds = detailEpisode.characters.compactMap { urlString in
        urlString.components(separatedBy: "/").last
      }.joined(separator: ",")
      
      let url = "character/\(charactersIds)"
      let response: [RMCharacter] = try await networkService.fetch(url)
      
      characters = response
//      let url = "episode/\(detailEpisode.id)"
//      let response: RMDetailEpisodeResponse = try await networkService.fetch(url)
//      self.detailEpisode = response.results
    } catch {
      self.error = error.localizedDescription
    }
    isLoading = false
  }
}



