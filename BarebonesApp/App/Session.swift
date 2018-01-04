import KeychainSwift
import Moya
import ReactiveMoya
import ReactiveSwift

public class Session {
  public static let shared = Session()
  private init() {}

  public var userId: String? {
    return KeychainSwift().get(Keychain.userId)
  }

  public lazy var api: ReactiveSwiftMoyaProvider<Api>! = {
    return self.userId
      .flatMap { Token.encode(id: $0) }
      .map { $0.token }
      .map { AccessTokenPlugin(token: $0) }
      .map { (authPlugin) in
        ReactiveSwiftMoyaProvider<Api>(
          plugins: [
            authPlugin,
            //            NetworkLoggerPlugin()
          ])
    }
  }()

  func fetchUser() -> SignalProducer<User, ClientError> {
    return SignalProducer { observer, _ in
      Session.shared.api?.request(.showUser)
        .filterSuccessfulStatusCodes()
        .mapJSON()
        .startWithResult { result in
          switch result {
          case .failure(let error):
            print(error)
            observer.send(error: .fetchUser)
          case .success(let response):
            if let user: User = decode(response) {
              observer.send(value: user)
            }
          }
      }
    }
  }
}
