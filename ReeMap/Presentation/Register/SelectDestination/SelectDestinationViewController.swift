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
    private var currentCoodinate: CLLocation?
    
    var didRecieveAnnotations: [Annotation]? {
        didSet {
            guard let annotations = didRecieveAnnotations else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [unowned self] in
                self.ui.mapView.removeAnnotations(self.ui.mapView.annotations)
                self.ui.mapView.addAnnotations(annotations)
            }
        }
    }
    
    init() {
        currentLocation = LocationService.sharedInstance.currentLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        super.loadView()
        ui.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                self.validatePinsDistant { [unowned self] in
                    self.routing?.showCreateMemoPage(address: self.streetAddress)
                }
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
            ui.mapView.setRegion(region, animated: true)
            isInitialZoom = false
        }
    }
    
    private func updateStreetAddress(placemark: CLPlacemark) {
        guard
            let administrativeArea = placemark.administrativeArea,
            let locality = placemark.locality,
            let thoroughfare = placemark.thoroughfare,
            let subThoroughfare = placemark.subThoroughfare
        else { return }
        if self.isFirstInput { self.isFirstInput = false; return }
        let streetAddress = "\(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)"
        self.streetAddress = streetAddress
        ui.setStreetAddress(streetAddress)
    }
    
    func recieveStreetAddress(_ address: String?) {
        guard let streetAddress = address?.getStreetAddress() else { return }
        self.streetAddress = streetAddress
        ui.setStreetAddress(streetAddress)
    }
    
    func validatePinsDistant(completion: (() -> Void)) {
        didRecieveAnnotations?.forEach { [unowned self] in
            let coodinate = CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
            if coodinate.distance(from: self.currentCoodinate ?? CLLocation()) <= 50 {
                self.showAutomaticallyDisappearAlert(title: R.string.localizable.attention_title(),
                                                     message: R.string.localizable.attention_close_pin(),
                                                     deadline: .now() + 1)
                return
            }
        }
        completion()
    }
}

extension SelectDestinationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        guard
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier,
                                                                       for: annotation) as? MKMarkerAnnotationView,
            let customAnnotation = annotation as? Annotation
        else { return MKMarkerAnnotationView() }
        annotationView.markerTintColor = customAnnotation.color
        annotationView.clusteringIdentifier = Constants.DictKey.clusteringIdentifier
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        currentCoodinate = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        viewModel?.getPlacemarks(location: currentCoodinate ?? CLLocation())
            .subscribe(onSuccess: { [unowned self] placemark in
                self.updateStreetAddress(placemark: placemark)
                }, onError: { [unowned self] _ in
                    self.showAttentionAlert(message: R.string.localizable.attention_could_not_load_location())
            }).disposed(by: disposeBag)
    }
}
