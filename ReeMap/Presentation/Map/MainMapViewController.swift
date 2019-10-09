import CoreLocation
import FloatingPanel
import Foundation
import MapKit
import RxCocoa
import RxSwift
import UIKit
import UserNotifications

extension MainMapViewController: VCInjectable {
    
    typealias UI = MainMapUIProtocol
    typealias Routing = MainMapRoutingProtocol
    typealias ViewModel = MainMapViewModel
    typealias PanelDelegate = FloatingPanelDelegate
    
    func setupConfig() {
        ui.noteFloatingPanel.delegate = listPanelDelegate
        ui.noteDetailFloatingPanel.delegate = detailPanelDelegate
        ui.mapView.delegate = self
        ui.noteListVC.tappedSearchBarDelegate = self
        ui.noteListVC.tappedCellDelegate = self
        ui.sideMenuVC.delegate = self
    }
}

final class MainMapViewController: UIViewController {
    
    var ui: MainMapUIProtocol! { didSet { ui.viewController = self } }
    var routing: MainMapRoutingProtocol? { didSet { routing?.viewController = self } }
    var viewModel: MainMapViewModel?
    var disposeBag: DisposeBag!
    
    private var isShownSidemenu: Bool { return ui.sideMenuVC.parent == self }
    
    // swiftlint:disable all
    private lazy var listPanelDelegate: PanelDelegate = {
        FloatingPanelDelegate(panel: BasicPanelLayout(panel: .tipPanel),
           panelLayoutforHandler:
        { [unowned self] _, _ in
            self.ui.noteListVC.ui.changeTableAlpha(0.2)
        }, panelaDidMoveHandler:
        { [unowned self] progress in
            self.ui.noteListVC.ui.changeTableAlpha(progress)
        }, panelEndDraggingHandler:
        { [unowned self] _, _, targetPosition in
            self.ui.changePanelState(targetPosition: targetPosition)
            self.ui.animatePanelPosition(targetPosition, tipHandler: { [unowned self] in
                self.ui.noteListVC.ui.changeTableAlpha(0.2)
            }, defaultHandler: { [unowned self] in
                self.ui.noteListVC.ui.changeTableAlpha(1.0)
            })
        })
    }()
    
    private lazy var detailPanelDelegate: PanelDelegate = {
        FloatingPanelDelegate(panel: HiddenPanelLayout(panel: .hiddenPanel),
           panelLayoutforHandler:
        { [unowned self] _, _ in
            self.ui.noteDetailVC.changeTableAlpha(0.2)
        }, panelaDidMoveHandler:
        { [unowned self] progress in
            self.ui.noteDetailVC.changeTableAlpha(progress)
        }, panelEndDraggingHandler:
        { [unowned self] _, _, targetPosition in
            self.ui.changePanelState(targetPosition: targetPosition)
            self.ui.animatePanelPosition(targetPosition, tipHandler: { [unowned self] in
                self.ui.noteDetailVC.changeTableAlpha(0.2)
            }, defaultHandler: { [unowned self] in
                self.ui.noteDetailVC.changeTableAlpha(1.0)
            })
        })
    }()
    // swiftlint:disable:previou
    
    override func loadView() {
        super.loadView()
        ui.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        isExistUIDToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ui.addPanel(panel: ui.noteFloatingPanel)
        ui.addPanel(panel: ui.noteDetailFloatingPanel)
    }
}

extension MainMapViewController {
    
    private func bindUI() {
        let input = MainMapViewModel.Input(viewDidLayoutSubviews: rx.sentMessage(#selector(viewDidLayoutSubviews)).asObservable())
        let output = viewModel?.transform(input: input)
        
        output?.places
            .subscribe(onNext: { [unowned self] places in
                self.ui.noteListVC.didAcceptPlaces = places
            }).disposed(by: disposeBag)
        
        output?.error
            .subscribe(onNext: { [unowned self] _ in
                self.showError(message: R.string.localizable.error_message_network())
            }).disposed(by: disposeBag)
        
        output?.didAnnotationFetched
            .subscribe(onNext: { [unowned self] annotations in
                self.ui.updateAnnotations(annotations)
            }).disposed(by: disposeBag)
        
        output?.didLocationUpdated
            .subscribe(onNext: { [unowned self] location in
                self.ui.noteListVC.dataSource.listItems
                    .filter { $0.notification }
                    .forEach {
                        let destination = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
                        destination.distance(from: location) <= 200 ? self.createLocalNotification(place: $0) : ()
                    }
            }).disposed(by: disposeBag)
        
        ui.currentLocationBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.ui.setRegion(location: self.ui.mapView.userLocation.coordinate)
            }).disposed(by: disposeBag)
        
        ui.menuBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.ui.showSidemenu(isShownSidemenu: self.isShownSidemenu, contentAvailability: true, animated: true)
            }).disposed(by: disposeBag)
        
        ui.memoAddingBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.routing?.showSelectDestinationPage()
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
    
    private func isExistUIDToken() {
        guard let uid = viewModel?.getUIDToken() else { return }
        uid.isEmpty ? prosessInInitialAccess() : bindUI()
    }
    
    private func prosessInInitialAccess() {
        viewModel?.AuthenticateAnonymous()
            .subscribe(onSuccess: { [unowned self] auth in
                self.viewModel?.setUIDToken(auth.uid)
                self.bindUI()
            }, onError: { [unowned self] error in
                self.showError(message: R.string.localizable.error_message_network())
            }).disposed(by: disposeBag)
    }
    
    private func zoomTo(location: CLLocation) {
        viewModel?.zoomTo(location: location, left: {
            ui.setRegion(location: location.coordinate)
        }, right: {
            ui.mapView.setCenter(location.coordinate, animated: true)
        })
    }
    
    func createLocalNotification(place: Place) {
        let content = UNMutableNotificationContent()
        content.createLocalNotification(title: R.string.localizable.remind(),
                                        content: place.content,
                                        sound: UNNotificationSound.default,
                                        resource: (image: Constants.Resource.resource.image,
                                                   type: Constants.Resource.resource.type),
                                        requestIdentifier: Constants.Identifier.notification,
                                        notificationHandler: { [unowned self] in
            self.viewModel?.updateNote([Constants.DictKey.notification: false], noteId: place.documentId)
                .subscribe(onError: { [unowned self] _ in
                    self.showError(message: R.string.localizable.could_not_update_note())
                }).disposed(by: self.disposeBag)
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
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? Annotation else { return }
        ui.noteDetailVC.recieveData = (annotation.documentId ?? "", annotation.content ?? "", annotation.streetAddress ?? "")
        showHalfScreenNoteDetail()
    }
}

extension MainMapViewController: TappedSearchBarDelegate {
    
    func tappedSearchBar() {
        ui.showPanel(panel: ui.noteFloatingPanel, type: .full) { [unowned self] in
            self.ui.noteListVC.ui.changeTableAlpha(1.0)
        }
    }
    
    func showHalfScreenNoteDetail() {
        ui.showPanel(panel: ui.noteDetailFloatingPanel, type: .half) { [unowned self] in
            self.ui.noteDetailVC.changeTableAlpha(1.0)
        }
    }
}

extension MainMapViewController: TappedCellDelegate {
    
    func didselectCell(place: Place) {
        ui.noteDetailVC.recieveData = (place.documentId, place.content, place.streetAddress)
        showHalfScreenNoteDetail()
    }
}

extension MainMapViewController: SideMenuViewControllerDelegate {
    
    func sidemenuViewController(_ sidemenuViewController: SideMenuViewController, didSelectItemAt indexPath: IndexPath) {
        ui.hideSidemenu(isShownSidemenu: isShownSidemenu, animated: true)
        let menu = Menu.allCases[indexPath.row]
        switch menu {
        case .version:
            routing?.showVersionPage()
        case .privacy:
            routing?.showWebViewPage(url: Constants.RedirectURL.privacy)
        case .termsOfService:
            routing?.showWebViewPage(url: Constants.RedirectURL.termOfSearvice)
        case .contactUs:
            routing?.showWebViewPage(url: Constants.RedirectURL.contactUs)
        }
    }
}
