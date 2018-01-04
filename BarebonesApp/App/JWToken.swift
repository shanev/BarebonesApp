import Foundation
import JWT

//struct JWToken: Decodable {
//  let jwt: String
//}

struct JWToken {
  let value: String

  static func encode(id: String) -> JWToken {
    let token = JWT.encode(
      claims: ["id": id],
      algorithm: .hs256(Environment.jwtSecret.value.data(using: .utf8)!))

    return JWToken(value: token)
  }

  func decodeId() -> String? {
    do {
      let claims: ClaimSet = try JWT.decode(
        token,
        algorithm: .hs256(Environment.jwtSecret.value.data(using: .utf8)!)
      )
      return claims["id"] as? String
    } catch {
      print("Failed to decode JWT: \(error)")
      return nil
    }
  }

  func decodeUser() -> User? {
    do {
      var config = Configuration()
      let claims: ClaimSet = try JWT.decode(
        token,
        algorithm: .hs256(Environment.jwtSecret.value.data(using: .utf8)!))
      if let claim = claims["user"] {
        return decode(claim)
      }
    } catch {
      print("Failed to decode JWT: \(error)")
    }
    return nil
  }
}
