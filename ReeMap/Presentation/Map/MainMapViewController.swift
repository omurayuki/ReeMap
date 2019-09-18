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
    
    private struct Const {
        static let didUpdateLocation = "didUpdateLocation"
        static let showTurnOnLocationServiceAlert = "showTurnOnLocationServiceAlert"
    }
    
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
    }
}

extension MainMapViewController {
    
    private func setupUI() {
        ui.setup()
    }
    
    private func setupViewModel() {
        ui.currentLocationBtn.rx.tap.asDriver()
            .drive(onNext: { _ in
                print("hoge")
            }).disposed(by: disposeBag)
        
        ui.menuBtn.rx.tap.asDriver()
            .drive(onNext: { _ in
                print("hoge")
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: Const.didUpdateLocation))
            .subscribe(onNext: { [unowned self] notification in
                if let userInfo = notification.userInfo {
                    self.updatePolylines()
                    if let newLocation = userInfo["location"] as? CLLocation {
                        self.zoomTo(location: newLocation)
                    }
                }
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(Notification.Name(rawValue: Const.showTurnOnLocationServiceAlert))
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
            viewModel.inputs.setIsInitialZoom(true)
        }) {
            viewModel.inputs.setIsZoom(true)
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
        if viewModel.outputs.isZoom() == true {
            viewModel.inputs.setIsZoom(false)
            viewModel.inputs.setIsBlockingAutoZoom(false)
        } else {
            viewModel.inputs.setIsBlockingAutoZoom(true)
            let timer = viewModel.outputs.getZoomBlockingTimer()
            if timer.isValid { timer.invalidate() }
            viewModel.inputs.setZoomBlockingTimer(.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { [unowned self] _ in
                self.viewModel.inputs.setZoomBlockingTimer(nil)
                self.viewModel.inputs.setIsBlockingAutoZoom(false)
            }))
        }
    }
}
