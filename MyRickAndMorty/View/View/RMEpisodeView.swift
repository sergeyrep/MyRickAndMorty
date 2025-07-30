import SwiftUI

struct RMEpisodeView: View {
  @StateObject var viewModel: EpisodeViewModel
  
  var body: some View {
    NavigationStack {
      Group {
        if viewModel.isLoading && !viewModel.episode.isEmpty {
          ProgressView()
        } else if let error = viewModel.error {
          Text("Error: \(error)")
            .foregroundColor(.red)
        } else {
          contentView
        }
      }
      .navigationTitle("Episodes Rick&Morty")
      .task {
        await viewModel.loadFethchedEpisodes()
      }
    }
  }
  
  private var contentView: some View {
    ScrollView {
      LazyVStack(spacing: 12) {
        ForEach(viewModel.episode) { episode in
          EpisodeCard(episode: episode)
            .onAppear {
              viewModel.loadMoreIfNeeded(currentItem: episode)
            }
        }
        
        if viewModel.isLoading && !viewModel.episode.isEmpty {
          ProgressView()
            .padding(.vertical, 20)
        }
      }
      .padding()
    }
  }
}

struct EpisodeCard: View {
  let episode: RMEpisode
  
  private let bordeColors: [Color] = [
    .red, .green, .yellow, .orange, .pink,
      .purple, .blue, .indigo, .teal
  ]
  
  var body: some View {
    NavigationLink(destination: RMEpisodeDetailView(episode: episode)) {
      VStack(alignment: .leading, spacing: 8) {
        Text(episode.name)
          .font(.headline)
        
        HStack {
          Text(episode.episode)
            .font(.subheadline)
            .foregroundColor(.blue)
          
          Spacer()
          
          Text(episode.airDate ?? "HUI")
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
            bordeColors[episode.id % bordeColors.count],
            lineWidth: 1
          )
      )
      .shadow(radius: 3)
      .padding(.horizontal, 8)
    }
    .buttonStyle(PlainButtonStyle())
  }
}
