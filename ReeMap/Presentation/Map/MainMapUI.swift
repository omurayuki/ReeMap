import CoreLocation
import Foundation
import MapKit
import UIKit

protocol MainMapUIProtocol: UI {
    
    var mapView: MKMapView { get }
    var locationManager: CLLocationManager { get }
    var regionInMeters: Double { get }
    
    func centerViewOnUserLocation()
}

final class MainMapUI: MainMapUIProtocol {
    
    weak var rootView: UIView?
    
    private(set) var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        return mapView
    }()
    
    private(set) var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    
    private(set) var regionInMeters: Double = {
        10_000
    }()
}

extension MainMapUI {
    
    func setup() {
        guard let view = rootView else { return }
        [mapView].forEach { view.addSubview($0) }
        
//        mapView
        centerViewOnUserLocation()
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
}
