import SwiftUI

struct RMCharacterDetailView: View {
  @StateObject var viewModel: CharacterDetailViewModel
  
  init(viewModel: RMCharacter) {
    _viewModel = StateObject(wrappedValue: CharacterDetailViewModel(character: viewModel,
                                                                    networkService: RMNetworkService()))
  }
  
  var body: some View {
    ScrollView {
      if viewModel.isLoading {
        ProgressView()
      } else if let error = viewModel.error {
        Text("Error: \(error)")
      } else {
        AsyncImage(url: URL(string: viewModel.character.image)) { phase in
          if let image = phase.image {
            image
              .resizable()
              .scaledToFit()
              .padding()
              //.frame(width: 300, height: 300)
          }
        }
      }
      VStack {
        HStack {
          DetailInfo(value: "Species", info: viewModel.character.species, color: .red)
          Spacer()
          DetailInfo(value: "Status", info: viewModel.character.status, color: .blue)
        }
        HStack {
          DetailInfo(value: "Gender", info: viewModel.character.gender, color: .green)
          Spacer()
          DetailInfo(value: "Type", info: viewModel.character.type, color: .orange)
        }
      }
      .padding()
    }
    .navigationTitle(viewModel.character.name)
  }
}

struct DetailInfo: View {
  var value: String
  var info: String
  var color: Color = .blue
  
  var body: some View {
    VStack {
      HStack {
        Image(systemName: "bell")
          .foregroundColor(color)
        Text(info)
          .font(.subheadline)
      }
      Text(value)
        .font(.headline)
        .padding()
        .background(Color.gray.opacity(0.2))
        .foregroundColor(.blue)
        .cornerRadius(10)
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}


