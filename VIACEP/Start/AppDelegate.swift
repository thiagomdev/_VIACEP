import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigation = UINavigationController()
        let coordinator = Coordinator(navigation: navigation)
        
        window = UIWindow(frame: UIScreen.main.coordinateSpace.bounds)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        coordinator.perform(.home)

        createLocalNotification(center)
        
        return true
    }

    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    private func createLocalNotification(_ notifications: UNUserNotificationCenter) {
        notifications.delegate = self
        notifications.getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                let options: UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay]
                notifications.requestAuthorization(options: options) { success, error in
                    if error == nil {
                        print(success)
                    } else {
                        print(error!.localizedDescription)
                    }
                }
            } else if settings.authorizationStatus == .denied {
                print("Usuario negou a notificação")
            }
        }
        
        let confirmAction = UNNotificationAction(identifier: "Confirm", title: "Fechar", options: [.foreground])
        let category = UNNotificationCategory(identifier: "Lembrete", actions: [confirmAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", categorySummaryFormat: nil, options: [.customDismissAction])
        notifications.setNotificationCategories([category])
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        createLocalNotification(center)
        completionHandler([.banner])
    }
}
