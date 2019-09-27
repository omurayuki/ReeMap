import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift
import UIKit

final class SelectDestinationViewController: UIViewController {
    
    private(set) var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = false
        mapView.showsCompass = false
        mapView.showsScale = false
        return mapView
    }()
    
    var selectImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .green
        image.clipsToBounds = true
        image.layer.cornerRadius = 17.5
        return image
    }()
    
    var streetAddressLabel: UILabel = {
        let label = UILabel()
        label.apply(.h4, title: "hogehgoehogehoge")
        label.textAlignment = .center
        label.backgroundColor = .appLightGrey
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        return label
    }()
    
    var settingsBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.setTitle("設定する", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    var cancelBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.setTitle("キャンセル", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        mapView.delegate = self
    }
}

extension SelectDestinationViewController {
    
    func setup() {
        navigationItem.title = "目的地選択"
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [
            settingsBtn,
            cancelBtn
            ])
        stack.spacing = 20
        [mapView, streetAddressLabel, stack].forEach { view.addSubview($0) }
        mapView.addSubview(selectImage)
        
        mapView.anchor()
            .top(to: view.safeAreaLayoutGuide.topAnchor)
            .left(to: view.leftAnchor)
            .right(to: view.rightAnchor)
            .height(constant: view.frame.height * 0.5)
            .activate()
        
        selectImage.anchor()
            .centerToSuperview()
            .width(constant: 35)
            .height(constant: 35)
            .activate()
        
        streetAddressLabel.anchor()
            .centerXToSuperview()
            .top(to: mapView.bottomAnchor, constant: 30)
            .width(constant: view.frame.width * 0.9)
            .height(constant: 45)
            .activate()
        
        stack.anchor()
            .centerXToSuperview()
            .top(to: streetAddressLabel.bottomAnchor, constant: 25)
            .activate()
        
        settingsBtn.anchor()
            .top(to: streetAddressLabel.bottomAnchor, constant: 25)
            .width(constant: view.frame.width / 2 * 0.9)
            .height(constant: 45)
            .activate()
        
        cancelBtn.anchor()
            .top(to: streetAddressLabel.bottomAnchor, constant: 25)
            .width(constant: view.frame.width / 2 * 0.9)
            .height(constant: 45)
            .activate()
    }
}

extension SelectDestinationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { [unowned self] placemarks, error in
            // エラーハンドル
            guard let placemark = placemarks?.first else { return }
            if let error = error {
                print(error.localizedDescription)
            }
            
            self.streetAddressLabel.text = "\(placemark.administrativeArea ?? "") \(placemark.locality ?? "") \(placemark.thoroughfare ?? "") \(placemark.subThoroughfare ?? "")"
        }
    }
}
