import SwiftUI

@MainActor
final class CharactersViewModel: ObservableObject {
  @Published private(set) var characters: [RMCharacter] = []
  @Published private(set) var filteredCharacters: [RMCharacter] = []
  @Published private(set) var isLoading = false
  @Published private(set) var error: String?
  
  private let searchDebounceDelay: UInt64 = 500_000_000
  private let networkService: RMNetworkService
  private var currentPage = 1
  private var totalPages = 1
  private var searchTask: Task<Void, Never>?
  
  init(networkService: RMNetworkService) {
    self.networkService = networkService
  }
  
  func loadFethchedCharacters() async {
    guard !isLoading && currentPage <= totalPages else { return }
    
    isLoading = true
    error = nil
    
    do {
      let response: RMCharactersResponse = try await networkService.fetch("character/?page=\(currentPage)")
      characters.append(contentsOf: response.results)
      //filteredCharacters = characters
      totalPages = response.info.pages
      currentPage += 1
      
      if filteredCharacters.count == characters.count - response.results.count {
        filteredCharacters = characters
      }
    } catch {
      self.error = handleError(error) //error.localizedDescription
    }
    isLoading = false
  }
  
  func searchCharacters(text: String) {
    searchTask?.cancel()
    searchTask = Task {
      try? await Task.sleep(nanoseconds: searchDebounceDelay)
      guard !Task.isCancelled else { return }
      
      if text.isEmpty {
        resetSearch()
        //        await MainActor.run {
        //          filteredCharacters = characters
      } else {
        await performSearch(text: text)
      }
    }
  }
  
  private func resetSearch() {
    filteredCharacters = characters
    error = nil
  }
  
  private func handleError(_ error: Error) -> String {
    if let apiError = error as? NetworkError {
      return apiError.localizedDescription
    } else {
      return error.localizedDescription
    }
  }
  
  private func performSearch(text: String) async {
    do {
      let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
      let apiResponse: RMCharactersResponse = try await networkService.fetch("character/?name=\(query)")
      
      let localResults = characters.filter { $0.matchesSearch(text: text) }
      
      let combinedResults = (apiResponse.results + localResults).removingDuplicates()
      
      await MainActor.run {
        filteredCharacters = combinedResults
      }
    } catch {
      let localResults = characters.filter { $0.matchesSearch(text: text) }
      await MainActor.run {
        filteredCharacters = localResults
      }
    }
  }
  
  func loadMoreIfNeeded(currentItem item: RMCharacter?, isSearchActive: Bool) {
    guard !isSearchActive, !isLoading else { return }
    
    guard let item = item else {
      Task { await loadFethchedCharacters() }
      return
    }
    
    if let index = characters.firstIndex(of: item),
       index >= characters.count - 5 {
      Task { await loadFethchedCharacters() }
    }
    
    //    let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5)
    //    if characters.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
    //      Task { await loadFethchedCharacters() }
    //    }
  }
}
