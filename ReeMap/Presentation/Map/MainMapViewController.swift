import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift
import UIKit

extension MainMapViewController: VCInjectable {
    
    typealias UI = MainMapUIProtocol
    typealias Routing = MainMapRoutingProtocol
    typealias ViewModel = MainMapViewModelType
    
    func setupDI() {
        ui.rootView = self.view
        ui.locationManager.delegate = self
        routing.viewController = self
    }
}

final class MainMapViewController: UIViewController {
    
    var ui: MainMapUIProtocol!
    var routing: MainMapRoutingProtocol!
    var viewModel: MainMapViewModelType!
    var disposeBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDI()
        setupUI()
        setupViewModel()
    }
    
    private func setupUI() {
    }
    
    private func setupViewModel() {
        
    }
}

extension MainMapViewController {
    
    // TODO: Create LocationManager Class
    func checkLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            // TODO: Show alert letting the user know they have to turn this on.
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            ui.mapView.showsUserLocation = true
            ui.centerViewOnUserLocation()
            ui.locationManager.startUpdatingLocation()
        case .authorizedAlways:
            ui.mapView.showsUserLocation = true
            ui.centerViewOnUserLocation()
            ui.locationManager.startUpdatingLocation()
        case .denied:
            // TODO: prompt handling
            break
        case .notDetermined:
            // TODO: prompt handling
            ui.locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // TODO: prompt handling
            break
        default: break
        }
    }
}

// TODO: Create Delegate Class
extension MainMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: ui.regionInMeters,
                                        longitudinalMeters: ui.regionInMeters)
        ui.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
