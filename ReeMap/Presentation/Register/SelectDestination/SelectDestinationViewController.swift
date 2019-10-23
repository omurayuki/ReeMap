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
    
    override func loadView() {
        super.loadView()
        ui.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnnotations()
        bindUI()
        setupConfig()
        zoomTo()
        FirebaseAnalyticsUtil.setScreenName(.selectDestination, screenClass: String(describing: type(of: self)))
    }
}

extension SelectDestinationViewController {
    
    private func bindUI() {
        let input = ViewModel.Input(viewWillAppear: rx.sentMessage(#selector(viewWillAppear(_:))).asObservable(),
                                    regionWillChangeAnimated: rx.sentMessage(#selector(mapView(_:regionWillChangeAnimated:))).asObservable())
        let output = viewModel?.transform(input: input)
        
        output?.isUnreachable
            .subscribe(onNext: { isUnreachable in
                isUnreachable ? self.showError(message: R.string.localizable.error_message_network()) : ()
            }).disposed(by: disposeBag)
        
        output?.coodinatorConvertingSuccess
            .subscribe(onNext: { [unowned self] placemark in
                self.viewModel?.updateStreetAddress(placemark: placemark) { [unowned self] streetAddress in
                    self.ui.setStreetAddress(streetAddress)
                }
            }).disposed(by: disposeBag)
        
        output?.coodinatorConvertingError
            .subscribe(onNext: { [unowned self] _ in
                self.showAttentionAlert(message: R.string.localizable.attention_could_not_load_location())
            }).disposed(by: disposeBag)
        
        ui.streetAddressLabel.rx.isTextEmpty
            .skip(1)
            .drive(onNext: { [unowned self] bool in
                self.ui.changeSettingsBtnState(bool: bool)
            }).disposed(by: disposeBag)
        
        ui.tapGesture.rx.event.asDriver()
            .drive(onNext: { [unowned self] _ in
                guard let location = self.viewModel?.currentLocation else { return }
                self.routing?.showSearchStreetAddressPage(location: location)
            }).disposed(by: disposeBag)
        
        ui.settingsBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.viewModel?.validateIsCloseBetweenDistances(completion: { isClose in
                    if isClose {
                        self.showAutomaticallyDisappearAlert(title: R.string.localizable.attention_title(),
                                                             message: R.string.localizable.attention_close_pin(),
                                                             deadline: .now() + 1)
                    } else {
                        self.routing?.showCreateMemoPage(address: self.viewModel?.streetAddress ?? "")
                    }
                })
            }).disposed(by: disposeBag)
        
        ui.cancelBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.routing?.dismiss()
            }).disposed(by: disposeBag)
    }
}

extension SelectDestinationViewController {
    
    private func zoomTo() {
        viewModel?.zoomTo { [unowned self] region in
            self.ui.mapView.setRegion(region, animated: true)
        }
    }
    
    private func setAnnotations() {
        viewModel?.recieveAnnotationsHandler = { [unowned self] annotations in
            self.ui.mapView.removeAnnotations(self.ui.mapView.annotations)
            self.ui.mapView.addAnnotations(annotations)
        }
    }
    
    func recieveStreetAddress(_ address: String?) {
        guard let streetAddress = address?.getStreetAddress() else { return }
        self.viewModel?.streetAddress = streetAddress
        ui.setStreetAddress(streetAddress)
    }
}

// MARK: MKMapViewDelegate

extension SelectDestinationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier, for: annotation) as? MKMarkerAnnotationView,
            let customAnnotation = annotation as? Annotation else { return MKMarkerAnnotationView() }
        annotationView.markerTintColor = customAnnotation.color
        annotationView.clusteringIdentifier = Constants.DictKey.clusteringIdentifier
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {}
}
