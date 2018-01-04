import Foundation

// Environment variables are stored in Scheme -> Run -> Environment Variables

enum Environment: String {
  case baseUrl
  case jwtSecret

  var value: String {
    switch self {
    case .baseUrl:
      return ProcessInfo.processInfo.environment["BASE_URL"] ?? "http://api.example.com"
    case .jwtSecret:
      return ProcessInfo.processInfo.environment["JWT_SECRET"] ?? "secret"
    }
  }
}
