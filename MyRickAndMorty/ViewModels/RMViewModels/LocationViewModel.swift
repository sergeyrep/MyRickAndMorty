import Foundation

@MainActor
final class LocationViewModel: ObservableObject {
  @Published var location: [RMLocation] = []
  @Published var isLoading = false
  @Published var error: String?
  
  private var currentPage: Int = 1
  private var totalPages: Int = 1
  
  private let networkService: RMNetworkService
  
  init(networkService: RMNetworkService) {
    self.networkService = networkService
  }
  
  func loadFetchLocation() async {
    guard location.isEmpty else { return }
    await fetchLocations()
  }
  
  func fetchLocations() async {
    guard currentPage <= totalPages else { return }
    
    isLoading = true
    error = nil
    
    do {
      let url = "location?page=\(currentPage)"
      let response: RMLocationResponse = try await networkService.fetch(url)
      
      location.append(contentsOf: response.results)
      totalPages = response.info.pages
      currentPage += 1
      
    } catch {
      self.error = error.localizedDescription
    }
    isLoading = false
  }
  
  func loadMoreIfNeeded(currentItem item: RMLocation?) {
    guard let item = item else {
      Task { await fetchLocations() }
      return
    }
    
    let thresholdIndex = location.index(location.endIndex, offsetBy: -5)
    if location.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
      Task { await fetchLocations() }
    }
  }
}
