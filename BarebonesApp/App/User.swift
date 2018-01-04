public struct User {
  public let id: String
  public let deviceToken: String?

  public init(id: String,
              deviceToken: String? = nil) {
    self.id = id
    self.deviceToken = deviceToken
  }
}

//extension User: Decodable {
//  public static func decode(_ json: JSON) -> Decoded<User> {
//    return curry(User.init)
//      <^> json <| "_id"
//      <*> json <|? ["device", "token"]
//  }
//}
//
//extension User: EncodableType {
//  public func encode() -> [String : Any] {
//    var result: [String : Any] = [:]
//    result["id"] = self.id
//    result["device"] = ["token": self.deviceToken]
//
//    return result
//  }
//}

