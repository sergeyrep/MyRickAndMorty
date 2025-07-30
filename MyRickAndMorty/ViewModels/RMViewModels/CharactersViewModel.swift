//import SwiftUI
//
//@MainActor
//final class CharactersViewModel: ObservableObject {
//  @Published var characters: [RMCharacter] = []
//  @Published var isLoading = false
//  @Published var error: String?
//  @Published var filteredCharacters: [RMCharacter] = []
//
//  private var searchTask: Task<Void, Never>?
//
//  private var currentPage = 1
//  private var totalPages = 1
//
//  private let networkService: RMNetworkService
//
//  init(networkService: RMNetworkService) {
//    self.networkService = networkService
//  }
//
//  func searchDebounce(text: String) {
//    searchTask?.cancel()
//    searchTask = Task {
//      try? await Task.sleep(for: .milliseconds(500))
//      guard !Task.isCancelled else { return }
//      await searchCharacters(text: text)
//    }
//  }
//
//  private func searchCharacters(text: String) async {
//    if text.isEmpty {
//      filteredCharacters = characters
//    } else {
//      do {
//        let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let response: RMCharactersResponse = try await networkService.fetch("character/?name=\(query)")
//        filteredCharacters = response.results
//      }
//      //let endpoint = "character/?name=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
//
//      //      do {
//      //        let response: RMCharactersResponse = try await networkService.fetch(endpoint)
////        filteredCharacters = response.results
////      }
//      catch {
//        print("Search error:", error)
//        filteredCharacters = []
//      }
//    }
//  }
//
//  func loadFethchedCharacters() async {
//    guard characters.isEmpty else { return }
//    await fetchCharacters()
//  }
//
//  func fetchCharacters() async {
//    guard currentPage <= totalPages else { return }
//
//    isLoading = true
//    error = nil
//
//    do {
//      let url = "character?page=\(currentPage)"
//      let response: RMCharactersResponse = try await networkService.fetch(url)
//
//      characters.append(contentsOf: response.results)
//      filteredCharacters = characters
//      totalPages = response.info.pages
//      currentPage += 1
//    } catch {
//      self.error = error.localizedDescription
//    }
//
//    isLoading = false
//  }
//
//  func loadMoreIfNeeded(currentItem item: RMCharacter?) {
//    guard let item = item else {
//      Task { await fetchCharacters() }
//      return
//    }
//
//    let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5)
//    if characters.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
//      Task { await fetchCharacters() }
//    }
//  }
//}
//
//

import SwiftUI

@MainActor
final class CharactersViewModel: ObservableObject {
  @Published var characters: [RMCharacter] = []
  @Published var filteredCharacters: [RMCharacter] = []
  @Published var isLoading = false
  @Published var error: String?
  
  private var currentPage = 1
  private var totalPages = 1
  private var searchTask: Task<Void, Never>?
  let networkService: RMNetworkService
  
  init(networkService: RMNetworkService) {
    self.networkService = networkService
  }
  
  func loadFethchedCharacters() async {
    guard !isLoading else { return }
    
    isLoading = true
    error = nil
    
    do {
      let response: RMCharactersResponse = try await networkService.fetch("character/?page=\(currentPage)")
      characters.append(contentsOf: response.results)
      filteredCharacters = characters
      totalPages = response.info.pages
      currentPage += 1
    } catch {
      self.error = error.localizedDescription
    }
    
    isLoading = false
  }
  
  func searchDebounce(text: String) {
    searchTask?.cancel()
    searchTask = Task {
      try? await Task.sleep(nanoseconds: 500_000_000)
      guard !Task.isCancelled else { return }
      
      if text.isEmpty {
        await MainActor.run {
          filteredCharacters = characters
        }
      } else {
        await performSearch(text: text)
      }
    }
  }
  
  private func performSearch(text: String) async {
    do {
      // Сначала пробуем поиск по API (только по имени)
      let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
      let apiResponse: RMCharactersResponse = try await networkService.fetch("character/?name=\(query)")
      
      // Затем фильтруем локально по другим полям
      let localResults = characters.filter { character in
        character.matchesSearch(text: text)
      }
      
      // Объединяем результаты, устраняя дубликаты
      let combinedResults = (apiResponse.results + localResults).removingDuplicates()
      
      await MainActor.run {
        filteredCharacters = combinedResults
      }
    } catch {
      // Если API поиск не дал результатов, ищем только локально
      let localResults = characters.filter { $0.matchesSearch(text: text) }
      await MainActor.run {
        filteredCharacters = localResults
      }
    }
  }
  
  func loadMoreIfNeeded(currentItem item: RMCharacter?, isSearchActive: Bool) {
    guard !isSearchActive else { return }
    
    guard let item = item else {
      Task { await loadFethchedCharacters() }
      return
    }
    
    let thresholdIndex = characters.index(characters.endIndex, offsetBy: -5)
    if characters.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
      
      
      
      Task { await loadFethchedCharacters() }
    }
  }
}
