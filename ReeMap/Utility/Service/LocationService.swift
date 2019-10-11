import CoreLocation
import UIKit

final class LocationService: NSObject {
    
    static var sharedInstance = LocationService()
    let locationManager: CLLocationManager
    var locationDataArray: [CLLocation]
    var currentLocation: CLLocation!
    
    private override init() {
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = .fitness
        locationDataArray = [CLLocation]()
        
        super.init()
        
        locationManager.delegate = self
    }
    
    func requestAuthorization(completion: () -> Void) {
        locationManager.requestAlwaysAuthorization()
        completion()
    }
    
    func startUpdatingLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            break
        default:
            showTurnOnLocationServiceAlert()
        }
    }
    
    func startMonitoring() {
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func filterAndAddLocation(_ location: CLLocation) -> Bool {
        let age = -location.timestamp.timeIntervalSinceNow
        if age > 5 { return false }
        if location.horizontalAccuracy < 0 { return false }
        if location.horizontalAccuracy > 100 { return false }
        locationDataArray.append(location)
        
        return true
    }
    
    func showTurnOnLocationServiceAlert() {
        NotificationUtils.didUpdate(notification: .showTurnOnLocationServiceAlert)
    }
    
    func notifiyDidUpdateLocation(newLocation: CLLocation) {
        NotificationUtils.didUpdate(notification: .didUpdateLocation, userInfo: ["location": newLocation])
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            var locationAdded: Bool
            locationAdded = filterAndAddLocation(newLocation)
            if locationAdded {
                currentLocation = newLocation
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
