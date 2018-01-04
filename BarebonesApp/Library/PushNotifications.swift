import Foundation
import NotificationBanner
import UserNotifications

public final class PushNotifications: NSObject {
  public static let shared = PushNotifications()
  let center = UNUserNotificationCenter.current()

  public var window: UIWindow?

  private override init() {
    super.init()
    center.delegate = self
    setupCategories()
  }

  public func clearAll() {
    center.removeAllPendingNotificationRequests()
    center.removeAllDeliveredNotifications()
  }

  public func requestPushAccess() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
      if let error = error {
        print(error)
        assertionFailure(error.localizedDescription)
      }
      if granted {
        print("Granted push access.")
        UIApplication.shared.registerForRemoteNotifications()
      } else {
        print("Denied push access.")
      }
    }
  }

  public func setupCategories() {
    let replyAction = UNNotificationAction(
      identifier: "reply_action",
      title: "Reply",
      options: .foreground)

    let category = UNNotificationCategory(
      identifier: "category_id",
      actions: [replyAction],
      intentIdentifiers: [],
      options: .customDismissAction)

    let center = UNUserNotificationCenter.current()
    center.setNotificationCategories([category])
  }

  public func didRegisterForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    Session.shared.api?.request(.updateUser(
      deviceToken: token))
      .filterSuccessfulStatusCodes()
      .startWithResult { (result) in
        if let error = result.error {
          print(error)
        } else {
          print("Registered device token: \(token)")
        }
    }
  }

  public func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
    print(error)
  }
}

extension PushNotifications: UNUserNotificationCenterDelegate {
  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    print("Handle push from foreground")
    let banner = NotificationBanner(title: notification.request.content.body)
    banner.onTap = {
      self.notifyViewController(notification: notification)
    }
    banner.show()
  }

  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void) {
    print("Handle push from background or closed")
    notifyViewController(notification: response.notification)
  }
}

private extension PushNotifications {
  func notifyViewController(notification: UNNotification) {
    if let notificationId = notification.request.content.userInfo["notificationId"] as? String {
      NotificationCenter.default.post(
        Notification.init(
          name: .openedPushNotification,
          object: self,
          userInfo: ["notificationId": notificationId]))
    }
  }
}
