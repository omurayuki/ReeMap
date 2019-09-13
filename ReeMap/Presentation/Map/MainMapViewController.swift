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
    
    func setupConfig() {
        ui.mapView.delegate = self
    }
}

final class MainMapViewController: UIViewController {
    
    var ui: MainMapUIProtocol! { didSet { ui.viewController = self } }
    var routing: MainMapRoutingProtocol! { didSet { routing.viewController = self } }
    var viewModel: MainMapViewModelType!
    var disposeBag: DisposeBag!
    
    var isZooming: Bool?
    var isBlockingAutoZoom: Bool?
    var didInitialZoom: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        setupUI()
        setupViewModel()
        requestCurrentLocation()
    }
    
    private func setupUI() {
        ui.setup()
    }
    
    private func setupViewModel() {
        
    }
}

extension MainMapViewController {
    
    func requestCurrentLocation() {
        ui.locationManager.requestAlwaysAuthorization()
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways {
            ui.locationManager.startUpdatingLocation()
        }
    }
    
    // showTurnOnLocationServiceAlert
    
    func zoomTo(location: CLLocation) {
        if didInitialZoom == false {
            let coordinate = location.coordinate
            let region = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            ui.mapView.setRegion(region, animated: false)
            didInitialZoom = true
        }
        
        if isBlockingAutoZoom == false {
            isZooming = true
            ui.mapView.setCenter(location.coordinate, animated: true)
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
        switch status {
        case .authorizedAlways:
            // 位置情報取得の開始処理
            ui.locationManager.startUpdatingLocation()
        case .denied:
            showAttentionAlert(message: R.string.localizable.attention_message())
        case .authorizedWhenInUse:
            showAttentionAlert(message: R.string.localizable.attention_message())
        default: break
        }
    }
}

extension MainMapViewController: MKMapViewDelegate {
    
}
