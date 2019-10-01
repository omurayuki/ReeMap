import Firebase
import FirebaseAuth
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
        
        guard AppUserDefaultsUtils.getUIDToken() != nil else {
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let uid = authResult?.user.uid else { return }
                AppUserDefaultsUtils.setUIDToken(uid: uid)
            }
            return true
        }
        
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
