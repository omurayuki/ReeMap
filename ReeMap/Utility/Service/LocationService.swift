import Foundation
import CoreLocation

class LocationService: NSObject {
    
    var locationManager: CLLocationManager {
        didSet {
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.distanceFilter = 5
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false // trueにするとバッテリー消費量を抑えられるが、一度取得がされなくなるとフォアグラウンドにくるまで位置情報取得開始がされない
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
