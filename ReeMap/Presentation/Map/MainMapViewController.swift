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
    
    // - TODO: デバック用なので後で消す
    var polyline: MKPolyline?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        setupUI()
        setupViewModel()
        // 1
        let location = CLLocationCoordinate2D(latitude: 35.658581,
                                              longitude: 139.745433)
        
        // 2
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        ui.mapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        ui.mapView.addAnnotation(annotation)
    }
}

extension MainMapViewController {
    
    private func setupUI() {
        ui.setup()
    }
    
    private func setupViewModel() {
        viewModel.translate()
        
        ui.currentLocationBtn.rx.tap.asDriver()
            .drive(onNext: { _ in
                print("hoge")
            }).disposed(by: disposeBag)
        
        ui.menuBtn.rx.tap.asDriver()
            .drive(onNext: { _ in
                print("hoge")
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.didUpdateLocation)
            .subscribe(onNext: { [unowned self] notification in
                if let userInfo = notification.userInfo {
                    self.updatePolylines()
                    if let newLocation = userInfo["location"] as? CLLocation {
                        self.zoomTo(location: newLocation)
                    }
                }
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(.showTurnOnLocationServiceAlert)
            .subscribe(onNext: { [unowned self] _ in
                self.routing.showSettingsAlert {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url, options: [:])
                }
            }).disposed(by: disposeBag)
    }
    
    // - TODO: デバック用なので後で消す
    func updatePolylines() {
        var coordinateArray = [CLLocationCoordinate2D]()
        coordinateArray = LocationService.sharedInstance.locationDataArray.compactMap { $0.coordinate }
        clearPolyline()
        polyline = MKPolyline(coordinates: coordinateArray, count: coordinateArray.count)
        ui.mapView.addOverlay(polyline ?? MKPolyline())
    }
    
    // - TODO: デバック用なので後で消す
    func clearPolyline() {
        if polyline != nil {
            ui.mapView.removeOverlay(polyline ?? MKPolyline())
            polyline = nil
        }
    }
    
    private func zoomTo(location: CLLocation) {
        viewModel.outputs.zoomTo(location: location,
                                 left: {
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            ui.mapView.setRegion(region, animated: false)
        }) {
            ui.mapView.setCenter(location.coordinate, animated: true)
        }
    }
}

extension MainMapViewController: MKMapViewDelegate {
    
    // - TODO: デバック用なので後で消す
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? MKPolyline else { return MKOverlayRenderer() }
        let polylineRenderer = MKPolylineRenderer(polyline: overlay)
        polylineRenderer.strokeColor = .black
        polylineRenderer.alpha = 0.5
        polylineRenderer.lineWidth = 5.0
        return polylineRenderer
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        viewModel.outputs.changeZoomState()
    }
}
