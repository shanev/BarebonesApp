import JWT

public struct Token {
  public let token: String

  public static func encode(uuid: String) -> Token {
    var config = Configuration()
    let token = JWT.encode(claims: ["uuid": uuid],
                           algorithm: .hs256(config.environment.secret.data(using: .utf8)!))

    return Token(token: token)
  }

  public static func encode(id: String) -> Token {
    var config = Configuration()
    let token = JWT.encode(claims: ["id": id],
                           algorithm: .hs256(config.environment.secret.data(using: .utf8)!))

    return Token(token: token)
  }

  public func decodeId() -> String? {
    do {
      var config = Configuration()
      let claims: ClaimSet = try JWT.decode(token,
                                            algorithm: .hs256(config.environment.secret.data(using: .utf8)!))
      return claims["id"] as? String
    } catch {
      print("Failed to decode JWT: \(error)")
      return nil
    }
  }

  public func decodeUser() -> User? {
    do {
      var config = Configuration()
      let claims: ClaimSet = try JWT.decode(token,
                                            algorithm: .hs256(config.environment.secret.data(using: .utf8)!))
      if let claim = claims["user"] {
        return decode(claim)
      }
    } catch {
      print("Failed to decode JWT: \(error)")
    }
    return nil
  }
}

extension Token: Decodable {
  public static func decode(_ json: JSON) -> Decoded<Token> {
    return curry(Token.init)
      <^> json <| "jwt"
  }
}
