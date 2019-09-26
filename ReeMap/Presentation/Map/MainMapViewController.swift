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
        ui.noteFloatingPanel.delegate = panelDelegate
        ui.mapView.delegate = self
        noteListVC.delegate = self
        sideMenuVC.delegate = self
    }
}

final class MainMapViewController: UIViewController {
    
    var ui: MainMapUIProtocol! { didSet { ui.viewController = self } }
    var routing: MainMapRoutingProtocol? { didSet { routing?.viewController = self } }
    var viewModel: MainMapViewModel?
    var disposeBag: DisposeBag!
    
    let noteListVC = AppDelegate.container.resolve(NoteListViewController.self)
    let sideMenuVC = AppDelegate.container.resolve(SideMenuViewController.self)
    private var isShownSidemenu: Bool { return sideMenuVC.parent == self }
    
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
            switch targetPosition {
            case .tip:  self.ui.animateMemoBtnAlpha(1)
            case .half: self.ui.animateMemoBtnAlpha(0)
            case .full: self.ui.animateMemoBtnAlpha(0)
            default: break
            }
            UIView.Animator(duration: 0.25, options: .allowUserInteraction).animations { [unowned self] in
                switch targetPosition {
                case .tip: self.noteListVC.ui.changeTableAlpha(0.2)
                default:   self.noteListVC.ui.changeTableAlpha(1.0)
                }
            }.animate()
        })
    }()
    // swiftlint:disable:previou
    
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
        let output = viewModel?.transform(input: input)
        
        output?.places
            .subscribe(onNext: { [unowned self] places in
                self.noteListVC.didAcceptPlaces = places
            }).disposed(by: disposeBag)
        
        output?.error
            .subscribe(onNext: { [unowned self] _ in
                self.showError(message: R.string.localizable.error_message_network())
            }).disposed(by: disposeBag)
        
        output?.didAnnotationFetched
            .subscribe(onNext: { [unowned self] annotations in
                self.ui.mapView.addAnnotations(annotations)
            }).disposed(by: disposeBag)
        
        output?.didLocationUpdated
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel?.compareCoodinate()
            }).disposed(by: disposeBag)
        
        ui.currentLocationBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.ui.setRegion(location: self.ui.mapView.userLocation.coordinate)
            }).disposed(by: disposeBag)
        
        ui.menuBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.showSidemenu(animated: true)
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.didUpdateLocation)
            .subscribe(onNext: { [unowned self] notification in
                if let newLocation = notification.userInfo?[Constants.DictKey.location] as? CLLocation {
                    self.zoomTo(location: newLocation)
                    self.viewModel?.updateLocation(newLocation)
                }
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.showTurnOnLocationServiceAlert)
            .subscribe(onNext: { [unowned self] _ in
                self.routing?.showSettingsAlert {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    UIApplication.shared.open(url, options: [:])
                }
            }).disposed(by: disposeBag)
    }
}

extension MainMapViewController {
    
    private func zoomTo(location: CLLocation) {
        viewModel?.zoomTo(location: location,
                         left: {
            ui.setRegion(location: location.coordinate)
        }) {
            ui.mapView.setCenter(location.coordinate, animated: true)
        }
    }
    
    private func showSidemenu(contentAvailability: Bool = true, animated: Bool) {
        if isShownSidemenu { return }
        addChild(sideMenuVC)
        sideMenuVC.view.autoresizingMask = .flexibleHeight
        sideMenuVC.view.frame = view.bounds
        view.insertSubview(sideMenuVC.view, aboveSubview: view)
        sideMenuVC.didMove(toParent: self)
        if contentAvailability {
            sideMenuVC.showContentView(animated: animated)
        }
    }
    
    private func hideSidemenu(animated: Bool) {
        if !isShownSidemenu { return }
        sideMenuVC.hideContentView(animated: animated, completion: { (_) in
            self.sideMenuVC.willMove(toParent: nil)
            self.sideMenuVC.removeFromParent()
            self.sideMenuVC.view.removeFromSuperview()
        })
    }
}

extension MainMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        viewModel?.changeZoomState()
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

extension MainMapViewController: SideMenuViewControllerDelegate {
    
    func sidemenuViewController(_ sidemenuViewController: SideMenuViewController, didSelectItemAt indexPath: IndexPath) {
        hideSidemenu(animated: true)
    }
}
