import SwiftUI
import SDWebImage

struct RMCharactersView: View {
  @StateObject var viewModel: CharactersViewModel
  //  @State private var searchText = ""
  @State private var searchQuery = ""
  
  //Простой поиск
  //  var filterCharacters: [RMCharacter] {
  //    if searchText.isEmpty {
  //      return viewModel.characters
  //    } else {
  //      return viewModel.characters.filter {
  //        $0.name.localizedCaseInsensitiveContains(searchText) ||
  //        $0.gender.localizedCaseInsensitiveContains(searchText) ||
  //        $0.type.localizedCaseInsensitiveContains(searchText)
  //      }
  //    }
  //  }
  
  var body: some View {
    NavigationStack {
      contentView
        .navigationTitle("Rick and Morty")
        .task {
          await viewModel.loadFethchedCharacters()
        }
        .overlay {
          loadingProgress
        }
    }
  }
  
  @ViewBuilder
  private var loadingProgress: some View {
    if viewModel.isLoading && viewModel.filteredCharacters.isEmpty {
      ProgressView()
        .padding()
    }
    if let error = viewModel.error {
      Text("Error: \(error)")
        .foregroundColor(.red)
    }
  }
  
  private var contentView: some View {
    ScrollView {
      characterCards
      //progresView
        .padding()
    }
    .searchable(text: $searchQuery)
    .onChange(of: searchQuery) { newValue in
      viewModel.searchDebounce(text: newValue)
    }
  }
  
  @ViewBuilder
  private var progresView: some View {
    if viewModel.isLoading && !viewModel.characters.isEmpty {
      ProgressView()
        .padding()
    }
  }
  
  private var characterCards: some View {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 10) {
      ForEach(viewModel.filteredCharacters) { character in
        CharacterCard(character: character)
          .onAppear {
            viewModel.loadMoreIfNeeded(
              currentItem: character,
              isSearchActive: !searchQuery.isEmpty)
          }
      }
    }
    .padding()
  }
}

struct CharacterCard: View {
  let character: RMCharacter
  
  var body: some View {
    NavigationLink(destination: RMCharacterDetailView(viewModel: character)) {
      VStack(alignment: .leading) {
        AsyncImage(url: URL(string: character.image)) { phase in
          if let image = phase.image {
            image
              .resizable()
              .scaledToFit()
              .frame(height: 150)
              .cornerRadius(8)
          } else if phase.error != nil {
            Color.gray
              .frame(height: 150)
              .overlay {
                Image(systemName: "exclamationmark.triangle")
              }
          } else {
            ZStack {
              Color.clear
                .frame(height: 150)
              ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
          }
        }
        VStack(alignment: .leading, spacing: 4) {
          Text(character.name)
            .font(.headline)
            .lineLimit(1)
          HStack {
            Circle()
              .fill(statusColor)
              .frame(width: 8, height: 8)
            Text("\(character.status) - \(character.species)")
              .font(.caption)
          }
          .foregroundColor(.secondary)
        }
        .padding([.horizontal, .bottom], 8)
      }
      .background(Color(.systemBackground))
      .cornerRadius(12)
      .shadow(radius: 3)
    }
  }
  
  private var statusColor: Color {
    switch character.status.lowercased() {
    case "alive": return .green
    case "dead": return .red
    default: return .gray
    }
  }
}

#Preview {
  RMCharactersView(viewModel: .init(networkService: .init()))
}
