import SwiftUI

final class CharacterDetailViewModel: ObservableObject {
  @Published var character: RMCharacter
  @Published var isLoading = false
  @Published var error: String?
  
  
  private let networkService: RMNetworkService
  
  init(
    character: RMCharacter,
    networkService: RMNetworkService
  ) {
    self.character = character
    self.networkService = networkService
  }
  
  
  
  func fetchDetailCharacter() async {
    isLoading = true
    error = nil
    
    do {
      let url = "character/\(character.id)"
      let response: RMDetailCharacterResponse = try await networkService.fetch(url)
      self.character = response.results
    } catch {
      self.error = error.localizedDescription
    }
    isLoading = false
  }
}

extension CharacterDetailViewModel {
  static var mock: CharacterDetailViewModel {
    CharacterDetailViewModel(
      character: RMCharacter(
      id: 1,
      name: "Mock Character",
      status: "Chelovek",
      species: "Human",
      type: "",
      gender: "Male",
      origin: .init(name: "", url: ""),
      location: .init(name: "", url: ""),
      image: "https://via.placeholder.com/150",
      episode: [""],
      url: "",
      created: ""
      ),
      networkService: MockNetworkServiceCharacter()
    )
  }
}

class MockNetworkServiceCharacter: RMNetworkService {
  func fethc<T>(_ url: URL) async throws -> T where T : Decodable {
    let mockService = [
      RMCharacter(
        id: 1,
        name: "Mock Character",
        status: "Chelovek",
        species: "Human",
        type: "",
        gender: "Male",
        origin: .init(name: "", url: ""),
        location: .init(name: "", url: ""),
        image: "https://via.placeholder.com/150",
        episode: [],
        url: "",
        created: ""
      )
    ] as! T
    
    return mockService
  }
}
