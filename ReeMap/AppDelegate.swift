import CoreLocation
import Firebase
import RxCocoa
import RxSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    override init() {
        super.init()
        FirebaseApp.configure()
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = AppDelegate.container.resolve(MainMapViewController.self)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        requestLocationAndNotification()
        UNUserNotificationCenter.current().delegate = self
        if launchOptions?[UIApplication.LaunchOptionsKey.location] != nil {
            LocationService.sharedInstance.startMonitoring()
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        if CLLocationManager.significantLocationChangeMonitoringAvailable() {
            LocationService.sharedInstance.startMonitoring()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        LocationService.sharedInstance.startUpdatingLocation()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}

extension AppDelegate {
    
    func requestLocationAndNotification() {
        LocationService.sharedInstance.requestAuthorization(completion: {
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.badge, .sound, .alert],
                                      completionHandler: { [unowned self] granted, _ in
                    if !granted {
                        let alert = UIAlertController(title: R.string.localizable.error_title(),
                                                      message: R.string.localizable.attention_push_settings(),
                                                      preferredStyle: .alert)
                        let closeAction = UIAlertAction(title: R.string.localizable.close(), style: .default) { _ in
                            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                            UIApplication.shared.open(url, options: [:])
                        }
                        alert.addAction(closeAction)
                        self.window?.rootViewController?.present(alert, animated: true)
                    }
                })
        })
    }
}
