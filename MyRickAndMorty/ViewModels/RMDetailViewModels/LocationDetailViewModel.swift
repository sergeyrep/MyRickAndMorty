import Foundation

@MainActor
final class LocationDetailViewModel: ObservableObject {
  @Published var detailLocation: RMLocation
  @Published var residents: [RMCharacter] = []
  @Published var isLoading: Bool = false
  @Published var error: String?
  
  private let networkService: RMNetworkService
  
  init(location: RMLocation, networkServise: RMNetworkService) {
    self.detailLocation = location
    self.networkService = networkServise
  }
  
  func fetchLocationDetails() async {
    guard !detailLocation.residents.isEmpty else { return }
    
    isLoading = true
    residents.removeAll()
    error = nil
    
    do {
      let characterIds = detailLocation.residents.compactMap { urlString in
        urlString.components(separatedBy: "/").last
      }.joined(separator: ",")
      
      // Загружаем всех персонажей одним запросом
      let endpoint = "character/\(characterIds)"
      let characters: [RMCharacter] = try await networkService.fetch(endpoint)
      
      residents = characters
    
      
//      let url = "location\(detailLocation.id)"
//      let response: RMDetailLocationResponse = try await networkService.fetch(url)
//      self.detailLocation = response.results
      
    } catch {
      self.error = error.localizedDescription
    }
    isLoading = false
  }
}


extension LocationDetailViewModel {
  static var mock: LocationDetailViewModel {
    LocationDetailViewModel(
      location: RMLocation(
        id: 1,
        name: "Earth (C-137)",
        type: "Planet",
        dimension: "Dimension C-137",
        residents: [
          "https://rickandmortyapi.com/api/character/1",
          "https://rickandmortyapi.com/api/character/2"
        ],
        url: "https://rickandmortyapi.com/api/location/1",
        created: "2017-11-10T12:42:04.162Z"
      ),
      networkServise: MockNetworkService()
    )
  }
}

class MockNetworkService: RMNetworkService {
  func fetch<T>(_ url: URL) async throws -> T where T : Decodable {
    // Возвращаем моковые данные для превью
    let mockCharacters = [
      RMCharacter(
        id: 1,
        name: "Rick Sanchez",
        status: "Alive",
        species: "Human",
        type: "",
        gender: "Male",
        origin: .init(name: "Earth (C-137)", url: ""),
        location: .init(name: "Citadel of Ricks", url: ""),
        image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
        episode: [],
        url: "",
        created: ""
      )
    ] as! T
    
    return mockCharacters
  }
}
