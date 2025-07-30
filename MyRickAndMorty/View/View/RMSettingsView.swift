import SwiftUI

struct RMSettingsView: View {
  // Настройки храним в AppStorage или ViewModel
  @AppStorage("darkModeEnabled") private var darkModeEnabled = false
  @AppStorage("notificationsEnabled") private var notificationsEnabled = true
  @AppStorage("selectedTheme") private var selectedTheme = "System"
  @AppStorage("cacheSize") private var cacheSize = "0 MB"
  
  let themes = ["System", "Light", "Dark"]
  
  var body: some View {
    NavigationStack {
      Form {
        appearanceSection
        notificationsSection
        storageSection
        aboutSection
      }
      .navigationTitle("Settings")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Reset") {
            resetSettings()
          }
        }
      }
    }
  }
  
  private var appearanceSection: some View {
    Section(header: Text("APPEARANCE")) {
      Toggle("Dark Mode", isOn: $darkModeEnabled)
      
      Picker("Theme", selection: $selectedTheme) {
        ForEach(themes, id: \.self) { theme in
          Text(theme)
        }
      }
      
      NavigationLink {
        IconSelectorView()
      } label: {
        Text("App Icon")
      }
    }
  }
  
  private var notificationsSection: some View {
    Section(header: Text("NOTIFICATIONS")) {
      Toggle("Enable Notifications", isOn: $notificationsEnabled)
      
      if notificationsEnabled {
        DatePicker("Daily Reminder",
                   selection: .constant(Date()),
                   displayedComponents: .hourAndMinute)
      }
    }
  }
  
  private var storageSection: some View {
    Section(header: Text("STORAGE")) {
      HStack {
        Text("Cache Size")
        Spacer()
        Text(cacheSize)
          .foregroundColor(.gray)
      }
      
      Button("Clear Cache") {
        clearCache()
      }
      .foregroundColor(.red)
    }
  }
  
  private var aboutSection: some View {
    Section {
      NavigationLink {
        AboutAppView()
      } label: {
        Text("About App")
      }
      
      HStack {
        Text("Version")
        Spacer()
        Text(Bundle.main.versionNumber)
          .foregroundColor(.gray)
      }
    }
  }
  
  private func clearCache() {
    cacheSize = "0 MB"
  }
  
  private func resetSettings() {
    darkModeEnabled = false
    notificationsEnabled = true
    selectedTheme = "System"
  }
}

struct IconSelectorView: View {
  var body: some View {
    Text("App Icon Selector")
      .navigationTitle("App Icon")
  }
}

struct AboutAppView: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        Image("app_logo")
          .resizable()
          .frame(width: 100, height: 100)
          .cornerRadius(20)
        
        Text("Rick and Morty Explorer")
          .font(.title.bold())
        
        Text("Version \(Bundle.main.versionNumber)")
          .foregroundColor(.secondary)
        
        Text("This application provides information about characters, locations and episodes from Rick and Morty universe.")
          .multilineTextAlignment(.center)
          .padding()
        
        Link("Visit API Website",
             destination: URL(string: "https://rickandmortyapi.com")!)
        .buttonStyle(.bordered)
      }
      .padding()
    }
    .navigationTitle("About App")
  }
}

extension Bundle {
  var versionNumber: String {
    return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
  }
}

#Preview {
  RMSettingsView()
}
