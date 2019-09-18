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
    
    struct Const {
        static let didUpdateLocation = "didUpdateLocation"
        static let showTurnOnLocationServiceAlert = "showTurnOnLocationServiceAlert"
    }
    
    var ui: MainMapUIProtocol! { didSet { ui.viewController = self } }
    var routing: MainMapRoutingProtocol! { didSet { routing.viewController = self } }
    var viewModel: MainMapViewModelType!
    var disposeBag: DisposeBag!
    
    var polyline: MKPolyline?
    var isZooming: Bool?
    var isBlockingAutoZoom: Bool?
    var zoomBlockingTimer: Timer?
    var didInitialZoom: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        setupUI()
        setupViewModel()
        
        self.didInitialZoom = false
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
    
    func updatePolylines() {
        var coordinateArray = [CLLocationCoordinate2D]()
        coordinateArray = LocationService.sharedInstance.locationDataArray.compactMap { $0.coordinate }
        self.clearPolyline()
        self.polyline = MKPolyline(coordinates: coordinateArray, count: coordinateArray.count)
        ui.mapView.addOverlay(polyline ?? MKPolyline())
    }
    
    func clearPolyline() {
        if self.polyline != nil {
            ui.mapView.removeOverlay(polyline ?? MKPolyline())
            self.polyline = nil
        }
    }

    func zoomTo(location: CLLocation) {
        if self.didInitialZoom == false {
            let coordinate = location.coordinate
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
            ui.mapView.setRegion(region, animated: false)
            self.didInitialZoom = true
        }
        if self.isBlockingAutoZoom == false {
            self.isZooming = true
            ui.mapView.setCenter(location.coordinate, animated: true)
        }
    }
}

extension MainMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let overlay = overlay as? MKPolyline else { return MKOverlayRenderer() }
        let polylineRenderer = MKPolylineRenderer(polyline: overlay)
        polylineRenderer.strokeColor = .black
        polylineRenderer.alpha = 0.5
        polylineRenderer.lineWidth = 5.0
        return polylineRenderer
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        if self.isZooming == true {
            self.isZooming = false
            self.isBlockingAutoZoom = false
        } else {
            self.isBlockingAutoZoom = true
            if let timer = self.zoomBlockingTimer {
                if timer.isValid {
                    timer.invalidate()
                }
            }
            self.zoomBlockingTimer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: false, block: { _ in
                self.zoomBlockingTimer = nil
                self.isBlockingAutoZoom = false
            })
        }
    }
}
