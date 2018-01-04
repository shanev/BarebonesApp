// swiftlint:disable line_length

import Alamofire
import JWT
import Foundation
import Moya

public enum Api {
  case createUser
  case getUser
  case updateUser(deviceToken: String?)
}

extension Api: TargetType, AccessTokenAuthorizable {
  /// The target's base `URL`.
  public var baseURL: URL {
    return URL(string: "\(Environment.baseUrl.value)/api/v1")!
  }

  /// The path to be appended to `baseURL` to form the full `URL`.
  public var path: String {
    switch self {
    case .getUser, .updateUser:
      return "/users/self"
    case .createUser:
      return "/users"
    }
  }

  /// The HTTP method used in the request.
  public var method: Moya.Method {
    switch self {
    case .getUser:
      return .get
    case .createUser:
      return .post
    case .updateUser:
      return .put
    }
  }

  /// The parameters to be encoded in the request.
  public var parameters: [String : Any]? {
    switch self {
    case .createUser, .getUser:
      return nil
    case let .updateUser(deviceToken):
      if let token = deviceToken {
        params["device.token"] = token
      }
      return params
    }
  }

  /// The method used for parameter encoding.
  public var parameterEncoding: ParameterEncoding {
    return JSONEncoding.default
  }

  /// Provides stub data for use in testing.
//  public var sampleData: Data {
//  }

  /// The type of HTTP task to be performed.
  public var task: Task {
    return .request
  }

  /// AccessTokenAuthorizable
  public var shouldAuthorize: Bool {
    switch self {
    case .createUser:
      return false
    default:
      return true
    }
  }
}
