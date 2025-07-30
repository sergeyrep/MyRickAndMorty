import SwiftUI

struct RMMainView: View {
  var body: some View {
    TabView {
      makeCharactersView()
      
      makeLocationView()
      
      makeEpisodeView()
        
      RMSettingsView()
        .tabItem {
          Image(systemName: "gearshape")
          Text("Settings")
        }
    }
  }
  
  private func makeLocationView() -> some View {
    let viewModel = Factory.shared.makeLocationViewModel()
    return RMLocationView(viewModel: viewModel)
      .tabItem {
        Image(systemName: "map")
        Text("Locations")
      }
  }
  
  private func makeCharactersView() -> some View {
    let viewModel = Factory.shared.makeCharacterViewModel()
    return RMCharactersView(viewModel: viewModel)
      .tabItem {
        Image(systemName: "person.crop.circle")
        Text("Characters")
      }
  }
  
  private func makeEpisodeView() -> some View {
    let viewModel = Factory.shared.makeEpisodeViewModel()
    return RMEpisodeView(viewModel: viewModel)
      .tabItem {
        Image(systemName: "tv")
        Text("Episodes")
      }
  }
}

final class Factory {
    
  static let shared = Factory()
  
  lazy var networkService: RMNetworkService = {
    RMNetworkService()
  }()
  
  @MainActor
  func makeCharacterViewModel() -> CharactersViewModel {
    CharactersViewModel(networkService: networkService)
  }
  
  @MainActor
    func makeEpisodeViewModel() -> EpisodeViewModel {
    EpisodeViewModel(networkService: networkService)
  }
  
  @MainActor
  func makeLocationViewModel() -> LocationViewModel {
    LocationViewModel(networkService: networkService)
  }
}

#Preview {
  RMMainView()
}
