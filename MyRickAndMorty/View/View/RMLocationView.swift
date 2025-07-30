import SwiftUI

struct RMLocationView: View {
  @StateObject var viewModel: LocationViewModel
  
  var body: some View {
    NavigationStack {
      contentView
        .navigationTitle(Text("Locations"))
        .task {
          await viewModel.loadFetchLocation()
        }
        .overlay {
          if viewModel.isLoading && viewModel.location.isEmpty {
            ProgressView()
          }
          if let error = viewModel.error {
            Text("Error: \(error)")
              .foregroundColor(.red)
          }
        }
    }
  }
  
  @ViewBuilder
  private var progresView: some View {
    if viewModel.isLoading && !viewModel.location.isEmpty {
      ProgressView()
        .padding()
    }
  }
  
  private var contentView: some View {
    ScrollView {
      locationCards
      progresView
    }
  }
  
  private var locationCards: some View {
    LazyVStack {
      ForEach(viewModel.location) { location in
        LocationCard(location: location)
          .onAppear {
            viewModel.loadMoreIfNeeded(currentItem: location)
          }
      }
    }.padding()
  }
}

struct LocationCard: View {
  let location: RMLocation
  
  private let borderColors: [Color] = [
      .red, .blue, .green, .orange, .purple,
      .pink, .yellow, .mint, .teal, .indigo
  ]
  
  var body: some View {
    NavigationLink(destination: RMLocationDetailView(viewModel: .init(location: location, networkServise: .init()))) {
      VStack(alignment: .leading, spacing: 8) {
        Text(location.name)
          .font(.headline)
        
        HStack {
          Text(location.type)
            .font(.subheadline)
            .foregroundColor(.blue)
          Spacer()
          
          Text(location.dimension)
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
      }
      .padding()
      .background(Color(.systemBackground))
      .cornerRadius(10)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(
            borderColors[location.id % borderColors.count],
            lineWidth: 1
          )
      )
      .shadow(radius: 3)
      .padding(.horizontal, 8)
    }
    .buttonStyle(PlainButtonStyle())
  }
}

#Preview {
  RMLocationView(viewModel: .init(networkService: .init()))
}
