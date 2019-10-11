import Foundation
import Firebase

final class FirebaseAnalyticsUtil {
    
    public static func setScreenName(_ screenName: String?, screenClass: String?) {
        Analytics.setScreenName(screenName, screenClass: screenClass)
    }
    
    public static func setScreenName(_ screenName: ScreenName, screenClass: String?) {
        setScreenName(screenName.rawValue, screenClass: screenClass)
    }
}
