import CoreLocation
import UIKit

final class LocationService: NSObject {
    
    static var sharedInstance = LocationService()
    let locationManager: CLLocationManager
    var locationDataArray: [CLLocation]
    
    override init() {
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationDataArray = [CLLocation]()
        
        super.init()
        
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            showTurnOnLocationServiceAlert()
        }
    }
    
    func filterAndAddLocation(_ location: CLLocation) -> Bool {
        let age = -location.timestamp.timeIntervalSinceNow
        if age > 10 { return false }
        if location.horizontalAccuracy < 0 { return false }
        if location.horizontalAccuracy > 100 { return false }
        locationDataArray.append(location)
        
        return true
    }
    
    func showTurnOnLocationServiceAlert() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "showTurnOnLocationServiceAlert"), object: nil)
    }
    
    func notifiyDidUpdateLocation(newLocation: CLLocation) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "didUpdateLocation"), object: nil, userInfo: ["location": newLocation])
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            var locationAdded: Bool
            locationAdded = filterAndAddLocation(newLocation)
            if locationAdded {
                notifiyDidUpdateLocation(newLocation: newLocation)
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: Error) {
        if (error as NSError).domain == kCLErrorDomain && (error as NSError).code == CLError.Code.denied.rawValue {
            showTurnOnLocationServiceAlert()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        startUpdatingLocation()
    }
}
