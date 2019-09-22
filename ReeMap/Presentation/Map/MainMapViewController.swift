import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift
import UIKit

extension MainMapViewController: VCInjectable {
    
    typealias UI = MainMapUIProtocol
    typealias Routing = MainMapRoutingProtocol
    typealias ViewModel = MainMapViewModel
    
    func setupConfig() {
        ui.mapView.delegate = self
    }
}

final class MainMapViewController: UIViewController {
    
    var ui: MainMapUIProtocol! { didSet { ui.viewController = self } }
    var routing: MainMapRoutingProtocol! { didSet { routing.viewController = self } }
    var viewModel: MainMapViewModel!
    var disposeBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        setupUI()
        setupViewModel()
    }
}

extension MainMapViewController {
    
    private func setupUI() {
        ui.setup()
    }
    
    private func setupViewModel() {
        let input = MainMapViewModel.Input(viewWillAppear: rx.sentMessage(#selector(viewWillAppear(_:))).asObservable())
        let output = viewModel.transform(input: input)
        
        output.places
            .subscribe(onNext: { _ in }).disposed(by: disposeBag)
        
        output.error
            .subscribe(onNext: { [unowned self] _ in
                self.showError(message: R.string.localizable.error_message_network())
            }).disposed(by: disposeBag)
        
        output.didAnnotationFetched
            .subscribe(onNext: { [unowned self] annotations in
                self.ui.mapView.addAnnotations(annotations)
            }).disposed(by: disposeBag)
        
        output.didLocationUpdated
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel.compareCoodinate()
            }).disposed(by: disposeBag)
        
        ui.currentLocationBtn.rx.tap.asDriver()
            .drive(onNext: { _ in
                print("hoge")
            }).disposed(by: disposeBag)
        
        ui.menuBtn.rx.tap.asDriver()
            .drive(onNext: { _ in
                print("hoge")
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.didUpdateLocation)
            .subscribe(onNext: { [unowned self] notification in
                if let newLocation = notification.userInfo?[Constants.DictKey.location] as? CLLocation {
                    self.zoomTo(location: newLocation)
                    self.viewModel.updateLocation(newLocation)
                }
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.showTurnOnLocationServiceAlert)
            .subscribe(onNext: { [unowned self] _ in
                self.routing.showSettingsAlert {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url, options: [:])
                }
            }).disposed(by: disposeBag)
    }
    
    private func zoomTo(location: CLLocation) {
        viewModel.zoomTo(location: location,
                         left: {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            ui.mapView.setRegion(region, animated: true)
        }) {
            ui.mapView.setCenter(location.coordinate, animated: true)
        }
    }
}

extension MainMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        viewModel.changeZoomState()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        guard
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.DictKey.annotationView) as? MKMarkerAnnotationView
        else { return MKMarkerAnnotationView() }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? Annotation else { return }
        print(annotation.title)
    }
}
