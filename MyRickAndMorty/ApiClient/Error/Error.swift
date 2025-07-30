import Foundation

enum NetworkError: Error {
  case invalidURL
  case invalidResponse
  case decodingError
  case serverError(Int)
  case unknown
}

