import Foundation
import CoreLocation

class LocationService: NSObject {
    
    var locationManager: CLLocationManager {
        didSet {
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = true // バッテリー消費量を抑えられる
        }
    }
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        self.locationManager.requestWhenInUseAuthorization()
        super.init()
        self.locationManager.delegate = self
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")
        }
    }
}
