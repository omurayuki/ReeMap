import Firebase
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
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        LocationService.sharedInstance.requestAuthorization()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {
        LocationService.sharedInstance.startUpdatingLocation()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}
