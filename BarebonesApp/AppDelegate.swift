import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  let pushProvider = PushNotifications.shared

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    pushProvider.window = window

    var config = Configuration.shared
    print("Loaded environment: \(config.environment)")

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    application.applicationIconBadgeNumber = 0
    pushProvider.clearAll()
  }

  func applicationWillTerminate(_ application: UIApplication) {
  }
}

// MARK: Push Notifications

extension AppDelegate {
  func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    pushProvider.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
  }

  func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error) {
    pushProvider.didFailToRegisterForRemoteNotificationsWithError(error)
  }
}
