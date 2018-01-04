import Foundation

// Environment variables are stored in Scheme -> Run -> Environment Variables

enum Environment: String {
  case jwtSecret

  var value: String {
    switch self {
    case .jwtSecret:
      return ProcessInfo.processInfo.environment["JWT_SECRET"] ?? "secret"
    }
  }
}
