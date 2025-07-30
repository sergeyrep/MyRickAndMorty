import Foundation


struct RMCharactersResponse: Codable {
  let info: RMResponseInfo
  let results: [RMCharacter]
}

struct RMResponseInfo: Codable {
  let count: Int
  let pages: Int
  let next: String?
  let prev: String?
  
  private enum CodingKeys: String, CodingKey {
    case count
    case pages
    case next = "next"    // Маппинг для пагинации
    case prev = "prev"
  }
}

struct RMEpisodeResponse: Codable {
  let info: RMResponseInfo
  let results: [RMEpisode]
  
  private enum CodingKeys: String, CodingKey {
    case info
    case results
  }
}

struct RMDetailEpisodeResponse: Codable {
  let info: RMResponseInfo
  let results: RMEpisode
}

struct RMDetailCharacterResponse: Codable {
  let results: RMCharacter
}

struct RMLocationResponse: Codable {
  let info: RMResponseInfo
  let results: [RMLocation]
}

struct RMDetailLocationResponse: Codable {
  let info: RMResponseInfo
  let results: RMLocation
}
