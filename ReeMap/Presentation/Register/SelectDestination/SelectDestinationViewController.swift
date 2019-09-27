import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift
import UIKit

extension SelectDestinationViewController: VCInjectable {
    
    typealias UI = SelectDestinationUIProtocol
    typealias Routing = SelectDestinationRoutingProtocol
    typealias ViewModel = Nillable
    
    func setupConfig() {
        ui.mapView.delegate = self
    }
}

final class SelectDestinationViewController: UIViewController {
    
    var ui: SelectDestinationUIProtocol! { didSet { ui.viewController = self } }
    var routing: SelectDestinationRoutingProtocol? { didSet { routing?.viewController = self } }
    var viewModel: Nillable?
    var disposeBag: DisposeBag!
    
    private var streetAddress = String()
    private var isInitialZoom = true
    private var isFirstInput = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        bindUI()
        setupConfig()
        zoomTo(location: LocationService.sharedInstance.currentLocation)
    }
    
    deinit {
        print("deinit!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    }
}

extension SelectDestinationViewController {
    
    private func bindUI() {
        ui.streetAddressLabel.rx.isTextEmpty
            .skip(1)
            .drive(onNext: { [unowned self] bool in
                self.ui.changeSettingsBtnState(bool: bool)
            }).disposed(by: disposeBag)
        
        ui.settingsBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                guard !(self.ui.streetAddressLabel.text?.isEmpty ?? Bool()) else { return }
                self.routing?.showCreateMemoPage(address: self.streetAddress)
            }).disposed(by: disposeBag)
        
        ui.cancelBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}

extension SelectDestinationViewController {
    
    private func zoomTo(location: CLLocation) {
        if isInitialZoom {
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                                           longitude: location.coordinate.longitude),
                                            latitudinalMeters: 300,
                                            longitudinalMeters: 300)
            ui.mapView.setRegion(region, animated: false)
            isInitialZoom = false
        }
    }
}

extension SelectDestinationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { [unowned self] placemarks, error in
            guard let placemark = placemarks?.first else { return }
            if let _ = error {
                self.showAttentionAlert(message: R.string.localizable.attention_could_not_load_location())
            }
            guard
                let administrativeArea = placemark.administrativeArea,
                let locality = placemark.locality,
                let thoroughfare = placemark.thoroughfare,
                let subThoroughfare = placemark.subThoroughfare
            else { return }
            
            if self.isFirstInput {
                self.isFirstInput = false
                return
            }
            
            self.ui.streetAddressLabel.textColor = .black
            self.ui.streetAddressLabel.text = "\(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)"
            self.streetAddress = "\(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)"
        }
    }
}
