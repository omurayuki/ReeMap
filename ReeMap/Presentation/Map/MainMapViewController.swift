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
    typealias PanelDelegate = FloatingPanelDelegate
    
    func setupConfig() {
        ui.mapView.delegate = self
        ui.noteFloatingPanel.delegate = panelDelegate
        noteListVC.delegate = self
    }
}

final class MainMapViewController: UIViewController {
    
    var ui: MainMapUIProtocol! { didSet { ui.viewController = self } }
    var routing: MainMapRoutingProtocol! { didSet { routing.viewController = self } }
    var viewModel: MainMapViewModel!
    var disposeBag: DisposeBag!
    
    // swiftlint:disable all
    private lazy var panelDelegate: PanelDelegate = {
        FloatingPanelDelegate(panel: .tipPanel,
           panelLayoutforHandler:
        { [unowned self] _, _ in
            self.noteListVC.ui.changeTableAlpha(0.2)
        }, panelaDidMoveHandler:
        { [unowned self] progress in
            self.noteListVC.ui.changeTableAlpha(progress)
        }, panelEndDraggingHandler:
        { [unowned self] _, _, targetPosition in
            UIView.Animator(duration: 0.25, options: .allowUserInteraction).animations { [unowned self] in
                targetPosition == .tip ? (self.noteListVC.ui.changeTableAlpha(0.2)) : (self.noteListVC.ui.changeTableAlpha(1.0))
            }.animate()
        })
    }()
    // swiftlint:disable:previou

    let noteListVC = AppDelegate.container.resolve(NoteListViewController.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        setupUI()
        setupViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ui.addPanel()
    }
}

extension MainMapViewController {
    
    private func setupUI() {
        ui.setupFloating(contentVC: noteListVC, scrollView: noteListVC.ui.tableView)
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
            .drive(onNext: { [unowned self] _ in
                self.ui.setRegion(location: self.ui.mapView.userLocation.coordinate)
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
}

extension MainMapViewController {
    
    private func zoomTo(location: CLLocation) {
        viewModel.zoomTo(location: location,
                         left: {
            ui.setRegion(location: location.coordinate)
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
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier,
                                                                       for: annotation) as? MKMarkerAnnotationView
        else { return MKMarkerAnnotationView() }
        annotationView.clusteringIdentifier = Constants.DictKey.clusteringIdentifier
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? Annotation else { return }
        ui.noteFloatingPanel.move(to: .half, animated: true)
        noteListVC.ui.changeTableAlpha(0.9)
        noteListVC.ui.showHeader()
    }
}

extension MainMapViewController: TappedSearchBarDelegate {
    
    func tappedSearchBar() {
        ui.fullScreen() {
            self.noteListVC.ui.changeTableAlpha(1.0)
        }
    }
}
