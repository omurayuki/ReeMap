import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift
import UIKit

extension SelectDestinationViewController: VCInjectable {
    
    typealias UI = SelectDestinationUIProtocol
    typealias Routing = SelectDestinationRoutingProtocol
    typealias ViewModel = SelectDestinationViewModel
    
    func setupConfig() {
        ui.mapView.delegate = self
    }
}

final class SelectDestinationViewController: UIViewController {
    
    var ui: SelectDestinationUIProtocol! { didSet { ui.viewController = self } }
    var routing: SelectDestinationRoutingProtocol? { didSet { routing?.viewController = self } }
    var viewModel: SelectDestinationViewModel?
    var disposeBag: DisposeBag!
    
    private var streetAddress = String()
    private var isInitialZoom = true
    private var isFirstInput = true
    private var currentLocation: CLLocation?
    
    init() {
        currentLocation = LocationService.sharedInstance.currentLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        bindUI()
        setupConfig()
        zoomTo(location: currentLocation ?? CLLocation())
    }
}

extension SelectDestinationViewController {
    
    private func bindUI() {
        ui.streetAddressLabel.rx.isTextEmpty
            .skip(1)
            .drive(onNext: { [unowned self] bool in
                self.ui.changeSettingsBtnState(bool: bool)
            }).disposed(by: disposeBag)
        
        ui.tapGesture.rx.event.asDriver()
            .drive(onNext: { [unowned self] _ in
                guard let location = self.currentLocation else { return }
                self.routing?.showSearchStreetAddressPage(location: location)
            }).disposed(by: disposeBag)
        
        ui.settingsBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.routing?.showCreateMemoPage(address: self.streetAddress)
            }).disposed(by: disposeBag)
        
        ui.cancelBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.routing?.dismiss()
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
    
    private func updateStreetAddress(placemark: CLPlacemark) {
        guard
            let postcode = placemark.postalCode,
            let administrativeArea = placemark.administrativeArea,
            let locality = placemark.locality,
            let thoroughfare = placemark.thoroughfare,
            let subThoroughfare = placemark.subThoroughfare
        else { return }
        if self.isFirstInput { self.isFirstInput = false; return }
        self.ui.streetAddressLabel.textColor = .black
        self.ui.streetAddressLabel.text = "\(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)"
        self.streetAddress = "\(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)"
    }
    
    func recieveStreetAddress(_ address: String?) {
        ui.streetAddressLabel.textColor = .black
        var value = address!.components(separatedBy: ", ")
        if value[0].contains("〒") {
            value.removeFirst()
        }
        streetAddress = value.joined()
        ui.streetAddressLabel.text = value.joined()
    }
}

extension SelectDestinationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        viewModel?.getPlacemarks(location: location)
            .subscribe(onSuccess: { [unowned self] placemark in
                self.updateStreetAddress(placemark: placemark)
            }, onError: { [unowned self] _ in
                self.showAttentionAlert(message: R.string.localizable.attention_could_not_load_location())
            }).disposed(by: disposeBag)
    }
}
