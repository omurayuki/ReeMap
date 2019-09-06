import Foundation
import UIKit
import MapKit
import CoreLocation

protocol MapUIProtocol: UI {
    var mapView: MKMapView { get }
}

final class MapUI: MapUIProtocol {
    
    weak var rootView: UIView?
    
    private(set) var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        return mapView
    }()
    
    private var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
}

extension MapUI {
    
    func setup() {
        
    }
}
