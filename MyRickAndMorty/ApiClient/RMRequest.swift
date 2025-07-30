//import Foundation
//
//struct RMRequest {
//  let endpoint: RMEndpoint
//  var queryItems: [URLQueryItem] = []
//  
//  var url: URL? {
//    var components = URLComponents()
//    components.scheme = "https"
//    components.host = "rickandmortyapi.com"
//    components.path = "api/\(endpoint.rawValue)"
//    components.queryItems = queryItems.isEmpty ? nil : queryItems
//    
//    return components.url
//  }
//  
//  static func characters(name: String? = nil) -> RMRequest {
//    var queryItems = [URLQueryItem]()
//    if let name = name {
//      queryItems.append(URLQueryItem(name: "name", value: name))
//    }
//    return RMRequest(endpoint: .character, queryItems: queryItems)
//  }
//}
