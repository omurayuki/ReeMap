import CoreLocation
import Crashlytics
import Firebase
import RxCocoa
import RxSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    struct Const {
        
        static let launchScreen = "LaunchScreen"
        static let splashIdentifiler = "splash"
    }
    
    var window: UIWindow?
    
    override init() {
        super.init()
        FirebaseApp.configure()
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initUserDefault()
        launchScreen()
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
                        DispatchQueue.main.async { [unowned self] in
                            self.window?.rootViewController?.present(alert, animated: true)
                        }
                    }
                })
        })
    }
    
    func launchScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard
            let launchVC = UIStoryboard(name: Const.launchScreen,
                                        bundle: nil)
                .instantiateViewController(withIdentifier: Const.splashIdentifiler) as? SplashViewController
        else { return }
        launchVC.delegate = self
        self.window?.rootViewController = launchVC
        self.window?.makeKeyAndVisible()
    }
}

extension AppDelegate: SplashDelegate {
    
    func didFinishSplashAnimation() {
        requestLocationAndNotification()
        UNUserNotificationCenter.current().delegate = self
        let vc = AppDelegate.container.resolve(MainMapViewController.self)
        let nav = UINavigationController(rootViewController: vc)
        nav.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}

extension AppDelegate {
    
    private func initUserDefault() {
        AppUserDefaultsUtils.getRemindMeter() == 0.0 ? AppUserDefaultsUtils.setRangeMeter(200) : ()
    }
}
