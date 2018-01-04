struct Device: Codable {
  let token: String
}

struct User: Codable {
  let id: String
  let device: Device?

  enum CodingKeys: String, CodingKey {
    case id = "_id"
  }
}
