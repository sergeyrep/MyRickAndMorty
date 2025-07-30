import Foundation

struct RMCharacter: Identifiable, Codable, Hashable {
  let id: Int
  let name: String
  let status: String
  let species: String
  let type: String
  let gender: String
  let origin: RMOrigin
  let location: RMSingleLocation
  let image: String
  let episode: [String]
  let url: String
  let created: String
}

extension RMCharacter {
  func matchesSearch(text: String) -> Bool {
    let searchText = text.lowercased()
    return name.lowercased().contains(searchText) ||
    status.lowercased().contains(searchText) ||
    species.lowercased().contains(searchText) ||
    type.lowercased().contains(searchText) ||
    gender.lowercased().contains(searchText)
  }
}

extension Array where Element: Hashable {
  func removingDuplicates() -> [Element] {
    var seen = Set<Element>()
    return filter { seen.insert($0).inserted }
  }
}
