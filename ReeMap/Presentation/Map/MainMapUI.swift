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
    
    private(set) var currentLocationBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Icon-App-83.5x83.5-3"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private(set) var menuBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "Icon-App-83.5x83.5-1"), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private(set) var memoAddingBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.layer.cornerRadius = 25
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
        [mapView, currentLocationBtn, menuBtn, memoAddingBtn].forEach { vc.view.addSubview($0) }
        
        mapView.anchor()
            .centerToSuperview()
            .edgesToSuperview()
            .activate()
        
        currentLocationBtn.anchor()
            .top(to: mapView.topAnchor, constant: 35)
            .right(to: mapView.rightAnchor, constant: -20)
            .width(constant: 35)
            .height(constant: 35)
            .activate()
        
        menuBtn.anchor()
            .top(to: mapView.topAnchor, constant: 35)
            .left(to: mapView.leftAnchor, constant: 20)
            .width(constant: 35)
            .height(constant: 35)
            .activate()
        
        memoAddingBtn.anchor()
            .right(to: vc.view.rightAnchor, constant: -15)
            .bottom(to: vc.view.bottomAnchor, constant: -85)
            .width(constant: 50)
            .height(constant: 50)
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
}
