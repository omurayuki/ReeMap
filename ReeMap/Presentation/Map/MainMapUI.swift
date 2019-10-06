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
    
    func setRegion(location: CLLocationCoordinate2D)
    func setupFloating(contentVC: UIViewController, scrollView: UIScrollView)
    func addPanel()
    func removePanel()
    func fullScreen(completion: @escaping () -> Void)
    func animateMemoBtnAlpha(_ value: CGFloat)
    func updateAnnotations(_ annotations: [MKAnnotation])
    func animatePanelPosition(_ targetPosition: FloatingPanelPosition,
                              tipHandler: @escaping () -> Void,
                              defaultHandler: @escaping () -> Void)
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
}

extension MainMapUI {
    
    func setup() {
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
    
    func setupFloating(contentVC: UIViewController, scrollView: UIScrollView) {
        noteFloatingPanel.set(contentViewController: contentVC)
        noteFloatingPanel.track(scrollView: scrollView)
    }
    
    func addPanel() {
        guard let vc = viewController else { return }
        noteFloatingPanel.addPanel(toParent: vc, animated: true)
    }
    
    func removePanel() {
        noteFloatingPanel.removePanelFromParent(animated: true)
    }
    
    func fullScreen(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1) { [unowned self] in
            self.noteFloatingPanel.move(to: .full, animated: true)
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
}
