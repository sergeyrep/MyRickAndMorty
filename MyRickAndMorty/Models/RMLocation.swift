import Foundation

struct RMLocation: Identifiable, Codable {
  let id: Int
  let name: String
  let type: String
  let dimension: String
  let residents: [String]
  let url: String
  let created: String
}
