import CoreLocation
import Foundation

class LocationService: NSObject {
    
    var locationManager: CLLocationManager
    var locationDataArray: [CLLocation]
    var useFilter: Bool
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.distanceFilter = 5
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.requestWhenInUseAuthorization()
        locationDataArray = [CLLocation]()
        useFilter = true
        super.init()
        self.locationManager.delegate = self
    }
}

extension LocationService {
    
    func startUpdatingLocation() {
        #warning("何かユーザーにアクションを働きかける Onにしてください")
        CLLocationManager.locationServicesEnabled() ? locationManager.startUpdatingLocation() : ()
    }
    
    func filterAndAddLocation(_ location: CLLocation) -> Bool {
        let age = -location.timestamp.timeIntervalSinceNow
        if age > 10 { return false } // Locaiton is old.
        if location.horizontalAccuracy < 0 { return false } // Latitidue and longitude values are invalid.
        if location.horizontalAccuracy > 100 { return false } // Accuracy is too low.
        locationDataArray.append(location)
        return true
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")
            
            var locationAdded: Bool
            if useFilter {
                locationAdded = filterAndAddLocation(newLocation)
            } else {
                locationDataArray.append(newLocation)
                locationAdded = true
            }
            
            if locationAdded {
                // newLocationを使って処理
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        if (error as NSError).domain == kCLErrorDomain && (error as NSError).code == CLError.Code.denied.rawValue {
            //User denied your app access to location information.
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            //You can resume logging by calling startUpdatingLocation here
        }
    }
}
