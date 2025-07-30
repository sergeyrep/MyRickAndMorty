import Foundation

 class RMNetworkService {
  
  let baseURL = "https://rickandmortyapi.com/api/"
  
  func fetch<T: Decodable>(_ endpoint: String) async throws -> T {
    guard let url = URL(string: "\(baseURL)\(endpoint)") else {
      throw NetworkError.invalidURL
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    
    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
    if let jsonDict = jsonObject as? [String: Any] {
      print("Raw JSON:", jsonDict)
    }
    
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
      throw NetworkError.invalidResponse
    }
    
    do {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      return try decoder.decode(T.self, from: data)
    } catch {
      throw NetworkError.decodingError
    }
  }
}


