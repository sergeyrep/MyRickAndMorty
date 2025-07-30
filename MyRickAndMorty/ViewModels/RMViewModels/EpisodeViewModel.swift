import SwiftUI

@MainActor
final class EpisodeViewModel: ObservableObject {
  @Published var episode: [RMEpisode] = []
  @Published var isLoading = false
  @Published var error: String?
  
  private var currentPage = 1
  private var totalPages = 1
  
  private let networkService: RMNetworkService
  
  init(
    networkService: RMNetworkService)
  {
    self.networkService = networkService
  }
  
  func loadFethchedEpisodes() async {
    guard episode.isEmpty else { return }
    await fetchEpisode()
  }
  
  func fetchEpisode() async {
    guard !isLoading,
    currentPage <= totalPages else { return }
    
    isLoading = true
    error = nil
    
    do {
      let url = "episode?page=\(currentPage)"
      let response: RMEpisodeResponse = try await networkService.fetch(url)
      if Task.isCancelled { return }
      
      episode.append(contentsOf: response.results)
      totalPages = response.info.pages
      currentPage += 1
    } catch {
      if Task.isCancelled { return }
      self.error = error.localizedDescription
    }
    isLoading = false
  }
  
  func loadMoreIfNeeded(currentItem item: RMEpisode?) {
    guard let item = item else {
      Task { await fetchEpisode() }
      return
    }
    
    let thresholdIndex = episode.index(episode.endIndex, offsetBy: -5)
    if episode.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
      Task { await fetchEpisode() }
    }
  }
}
