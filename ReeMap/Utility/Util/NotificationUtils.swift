import Foundation
import CoreLocation

final class NotificationUtils {
    
    static func didUpdate<T: NSObject>(notification name: Notification.Name, userInfo: [String: T]? = nil) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
}

extension Notification.Name {
    
    enum Name: String {
        
        case showTurnOnLocationServiceAlert
        case attensionLocationServiceAlert
        case didUpdateLocation
    }
    
    static let showTurnOnLocationServiceAlert = Notification.Name(rawValue: Name.showTurnOnLocationServiceAlert.rawValue)
    static let attensionLocationServiceAlert = Notification.Name(rawValue: Name.attensionLocationServiceAlert.rawValue)
    static let didUpdateLocation = Notification.Name(rawValue: Name.didUpdateLocation.rawValue)
}
