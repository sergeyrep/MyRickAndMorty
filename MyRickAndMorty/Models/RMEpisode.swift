import Foundation

struct RMEpisode: Identifiable, Codable {
  let id: Int
  let name: String
  let airDate: String?
  let episode: String
  let characters: [String]
  let url: String
  let created: Date
  
  private enum CodingKeys: String, CodingKey {
    case id
    case name
    case airDate = "air_date"
    case episode
    case characters = "characters"
    case url
    case created = "created"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try container.decode(Int.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    airDate = try? container.decode(String.self, forKey: .airDate)
    episode = try container.decode(String.self, forKey: .episode)
    
    characters = try container.decode([String].self, forKey: .characters)
//    let urlString = try container.decode([String].self, forKey: .characters)
//    characters = urlString.compactMap { URL(string: $0) }
    
    url = try container.decode(String.self, forKey: .url)
    
    let dateString = try container.decode(String.self, forKey: .created)
    let formatter = ISO8601DateFormatter()
    created = formatter.date(from: dateString) ?? Date()
  }
}



// characters массив урл адресов, персонажы которые были замечены в данной серии

//"id": 1,
//      "name": "Pilot",
//      "air_date": "December 2, 2013",
//      "episode": "S01E01",
//      "characters": [
//        "https://rickandmortyapi.com/api/character/1",
//        "https://rickandmortyapi.com/api/character/2",
//        //...
//      ],
//      "url": "https://rickandmortyapi.com/api/episode/1",
//      "created": "2017-11-10T12:56:33.798Z"
