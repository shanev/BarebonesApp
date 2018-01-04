struct ClientError: Swift.Error {
  let reason: String
  static let badConnection = ClientError(reason: "Connection lost")
  static let fetchUser = ClientError(reason: "Error fetching user")
  static let invalidUser = ClientError(reason: "Invalid user")
}

extension ClientError: Equatable {
  static func ==(lhs: ClientError, rhs: ClientError) -> Bool {
    return lhs.reason == rhs.reason
  }
}
