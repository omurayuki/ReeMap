import CoreLocation
import FloatingPanel
import Foundation
import MapKit
import UIKit

protocol MainMapUIProtocol: UI {
    
    var mapView: MKMapView { get }
    var currentLocationBtn: UIButton { get }
    var menuBtn: UIButton { get }
    var memoAddingBtn: UIButton { get }
    var noteFloatingPanel: FloatingPanelController { get }
    var noteDetailFloatingPanel: FloatingPanelController { get }
    var noteListVC: NoteListViewController { get }
    var noteDetailVC: NoteDetailViewController { get }
    var sideMenuVC: SideMenuViewController { get }
    
    func setRegion(location: CLLocationCoordinate2D)
    func setupNoteListFloating(contentVC: UIViewController, scrollView: UIScrollView)
    func setupNoteDetailFloating(contentVC: UIViewController, scrollView: UIScrollView)
    func addPanel(panel: FloatingPanelController)
    func removeNoteListPanel(panel: FloatingPanelController)
    func showPanel(panel: FloatingPanelController, type: FloatingPanelPosition, completion: @escaping () -> Void)
    func animateMemoBtnAlpha(_ value: CGFloat)
    func updateAnnotations(_ annotations: [MKAnnotation])
    func animatePanelPosition(_ targetPosition: FloatingPanelPosition,
                              tipHandler: @escaping () -> Void,
                              defaultHandler: @escaping () -> Void)
    func showSidemenu(isShownSidemenu: Bool, contentAvailability: Bool, animated: Bool)
    func hideSidemenu(isShownSidemenu: Bool, animated: Bool)
    func changePanelState(targetPosition: FloatingPanelPosition)
}

final class MainMapUI: MainMapUIProtocol {
    
    weak var viewController: UIViewController?
    
    private(set) var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        mapView.showsScale = false
        return mapView
    }()
    
    private var currentLocationWrapView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private(set) var currentLocationBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "map"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private var menuWrapView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private(set) var menuBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private var memoAddingWrapView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.cornerRadius = 27.5
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private(set) var memoAddingBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "add"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private(set) var noteFloatingPanel: FloatingPanelController = {
        let fpc = FloatingPanelController()
        fpc.surfaceView.backgroundColor = .clear
        if #available(iOS 11, *) {
            fpc.surfaceView.cornerRadius = 13.0
        } else {
            fpc.surfaceView.cornerRadius = 0.0
        }
        fpc.surfaceView.shadowHidden = false
        return fpc
    }()
    
    private(set) var noteDetailFloatingPanel: FloatingPanelController = {
        let fpc = FloatingPanelController()
        fpc.surfaceView.backgroundColor = .clear
        if #available(iOS 11, *) {
            fpc.surfaceView.cornerRadius = 13.0
        } else {
            fpc.surfaceView.cornerRadius = 0.0
        }
        fpc.surfaceView.shadowHidden = false
        return fpc
    }()
    
    private(set) var noteListVC: NoteListViewController = {
        let noteListVC = AppDelegate.container.resolve(NoteListViewController.self)
        return noteListVC
    }()
    
    private(set) var noteDetailVC: NoteDetailViewController = {
        let noteDetailVC = AppDelegate.container.resolve(NoteDetailViewController.self)
        return noteDetailVC
    }()
    
    private(set) var sideMenuVC: SideMenuViewController = {
        let sideMenuVC = AppDelegate.container.resolve(SideMenuViewController.self)
        return sideMenuVC
    }()
}

extension MainMapUI {
    
    func setup() {
        setupNoteListFloating(contentVC: noteListVC, scrollView: noteListVC.ui.tableView)
        setupNoteDetailFloating(contentVC: noteDetailVC, scrollView: noteDetailVC.ui.tableView)
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        [mapView, currentLocationWrapView, menuWrapView, memoAddingWrapView].forEach { vc.view.addSubview($0) }
        currentLocationWrapView.addSubview(currentLocationBtn)
        menuWrapView.addSubview(menuBtn)
        memoAddingWrapView.addSubview(memoAddingBtn)
        
        mapView.anchor()
            .centerToSuperview()
            .edgesToSuperview()
            .activate()
        
        currentLocationWrapView.anchor()
            .top(to: mapView.topAnchor, constant: 35)
            .right(to: mapView.rightAnchor, constant: -15)
            .width(constant: 50)
            .height(constant: 50)
            .activate()
        
        currentLocationBtn.anchor()
            .centerToSuperview()
            .width(constant: 30)
            .height(constant: 30)
            .activate()
        
        menuWrapView.anchor()
            .top(to: mapView.topAnchor, constant: 35)
            .left(to: mapView.leftAnchor, constant: 15)
            .width(constant: 50)
            .height(constant: 50)
            .activate()
        
        menuBtn.anchor()
            .centerToSuperview()
            .width(constant: 25)
            .height(constant: 25)
            .activate()
        
        memoAddingWrapView.anchor()
            .right(to: vc.view.rightAnchor, constant: -15)
            .bottom(to: vc.view.bottomAnchor, constant: -85)
            .width(constant: 55)
            .height(constant: 55)
            .activate()
        
        memoAddingBtn.anchor()
            .centerToSuperview()
            .width(constant: 30)
            .height(constant: 30)
            .activate()
    }
    
    func setRegion(location: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
    }
    
    func setupNoteListFloating(contentVC: UIViewController, scrollView: UIScrollView) {
        noteFloatingPanel.set(contentViewController: contentVC)
        noteFloatingPanel.track(scrollView: scrollView)
    }
    
    func setupNoteDetailFloating(contentVC: UIViewController, scrollView: UIScrollView) {
        noteDetailFloatingPanel.set(contentViewController: contentVC)
        noteDetailFloatingPanel.track(scrollView: scrollView)
    }
    
    func addPanel(panel: FloatingPanelController) {
        guard let vc = viewController else { return }
        panel.addPanel(toParent: vc, animated: true)
    }
    
    func removeNoteListPanel(panel: FloatingPanelController) {
        panel.removePanelFromParent(animated: true)
    }
    
    func removeNoteDetailPanel() {
        noteDetailFloatingPanel.removePanelFromParent(animated: true)
    }
    
    func showPanel(panel: FloatingPanelController, type: FloatingPanelPosition, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1) {
            panel.move(to: type, animated: true)
            completion()
        }
    }
    
    func animateMemoBtnAlpha(_ value: CGFloat) {
        UIView.SpringAnimator(duration: 0.5, damping: 0.2, velocity: 1, options: .curveEaseOut)
            .animations { [unowned self] in
                self.memoAddingBtn.alpha = value
            }.animate()
    }
    
    func updateAnnotations(_ annotations: [MKAnnotation]) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    func animatePanelPosition(_ targetPosition: FloatingPanelPosition,
                              tipHandler: @escaping () -> Void,
                              defaultHandler: @escaping () -> Void) {
        UIView.Animator(duration: 0.25, options: .allowUserInteraction)
            .animations {
                switch targetPosition {
                case .tip: tipHandler()
                default:   defaultHandler()
                }
            }.animate()
    }
    
    func showSidemenu(isShownSidemenu: Bool, contentAvailability: Bool, animated: Bool) {
        guard let vc = viewController else { return }
        if isShownSidemenu { return }
        vc.addChild(sideMenuVC)
        sideMenuVC.view.autoresizingMask = .flexibleHeight
        sideMenuVC.view.frame = vc.view.bounds
        vc.view.insertSubview(sideMenuVC.view, aboveSubview: vc.view)
        sideMenuVC.didMove(toParent: vc)
        if contentAvailability {
            sideMenuVC.showContentView(animated: animated)
        }
    }
    
    func hideSidemenu(isShownSidemenu: Bool, animated: Bool) {
        if !isShownSidemenu { return }
        sideMenuVC.hideContentView(animated: animated, completion: { [unowned self] _ in
            self.sideMenuVC.willMove(toParent: nil)
            self.sideMenuVC.removeFromParent()
            self.sideMenuVC.view.removeFromSuperview()
        })
    }
    
    func changePanelState(targetPosition: FloatingPanelPosition) {
        switch targetPosition {
        case .tip:  animateMemoBtnAlpha(1.0)
        case .half: animateMemoBtnAlpha(0.0)
        case .full: animateMemoBtnAlpha(0.0)
        default: break
        }
    }
}
