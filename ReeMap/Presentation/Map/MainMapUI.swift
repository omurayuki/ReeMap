import CoreLocation
import Foundation
import MapKit
import UIKit

protocol MainMapUIProtocol: UI {
    
    var mapView: MKMapView { get }
    var currentLocationBtn: UIButton { get }
    var menuBtn: UIButton { get }
}

final class MainMapUI: MainMapUIProtocol {
    
    weak var viewController: UIViewController?
    
    private(set) var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
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
}

extension MainMapUI {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        [mapView, currentLocationBtn, menuBtn].forEach { vc.view.addSubview($0) }
        
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
    }
}
