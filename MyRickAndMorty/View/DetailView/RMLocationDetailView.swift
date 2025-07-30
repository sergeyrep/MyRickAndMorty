import SwiftUI

struct RMLocationDetailView: View {
  @StateObject var viewModel: LocationDetailViewModel
  
  //let detailLocation: RMLocation
  
  private let borderColors: [Color] = [
      .red, .blue, .green, .orange, .purple,
      .pink, .yellow, .mint, .teal, .indigo
  ]
  
  var body: some View {
    ScrollView {
      DetailInfoRow(label: "Location name", value: viewModel.detailLocation.name)
      DetailInfoRow(label: "Type", value: viewModel.detailLocation.type)
      DetailInfoRow(label: "Dimension", value: viewModel.detailLocation.dimension)
      DetailInfoRow(label: "Created", value: viewModel.detailLocation.created)
      Text("Resident: \(viewModel.detailLocation.residents.count)")
      if !viewModel.residents.isEmpty {
        residentSection
      } else if viewModel.isLoading {
        ProgressView()
      } else {
        Text("No resident found")
      }
    }
    .navigationTitle("Details Location")
    .task {
      await viewModel.fetchLocationDetails()
    }
  }
  
  private var residentSection: some View {
    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 8) {
      ForEach(viewModel.residents) { resident in
        NavigationLink {
          RMCharacterDetailView(viewModel: resident)
        } label: {
          CharacterCard(character: resident)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
  }
}


struct DetailInfoRow: View {
  var label: String
  var value: String
  
  var body: some View {
    HStack {
      Text(label)
      Spacer()
      Text(value)
    }
    .font(.headline)
    .padding()
    .background(Color.gray.opacity(0.2))
    .cornerRadius(10)
    .padding(.horizontal)
  }
}


#Preview {
  RMLocationDetailView(viewModel: .mock)
}
