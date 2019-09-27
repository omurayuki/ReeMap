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
        label.apply(.h5)
        label.textAlignment = .center
        label.backgroundColor = .appLightGrey
        label.layer.cornerRadius = 2
        label.textColor = .gray
        label.text = R.string.localizable.trace_map()
        label.clipsToBounds = true
        return label
    }()
    
    var settingsBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.setTitle(R.string.localizable.write_memo(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.alpha = CGFloat(0.2)
        button.isEnabled = false
        return button
    }()
    
    var cancelBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.setTitle(R.string.localizable.frame_selected_action_sheet_cancel(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    var streetAddress = String()
    
    let disposeBag = DisposeBag()
    
    var isInitialZoom = true
    
    var isFirstInput = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindUI()
        mapView.delegate = self
    }
    
    deinit {
        print("deinit!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    }
}

extension SelectDestinationViewController {
    
    func setup() {
        navigationItem.title = R.string.localizable.select_destination()
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
    
    func bindUI() {
        streetAddressLabel.rx.isTextEmpty
            .skip(1)
            .drive(onNext: { [unowned self] bool in
                bool ? (self.settingsBtn.alpha = CGFloat(1.0)) : (self.settingsBtn.alpha = CGFloat(0.2))
                self.settingsBtn.isEnabled = bool
            }).disposed(by: disposeBag)
        
        settingsBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                guard !(self.streetAddressLabel.text?.isEmpty ?? Bool()) else { return }
                let vc = CreateMemoViewController()
                vc.didRecieveStreetAddress = self.streetAddress
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        cancelBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.didUpdateLocation)
            .subscribe(onNext: { [unowned self] notification in
                if let newLocation = notification.userInfo?[Constants.DictKey.location] as? CLLocation {
                    if self.isInitialZoom {
                        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude), latitudinalMeters: 300, longitudinalMeters: 300)
                        self.mapView.setRegion(region, animated: false)
                        self.isInitialZoom = false
                    }
                }
            }).disposed(by: disposeBag)
    }
}

extension SelectDestinationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { [unowned self] placemarks, error in
            guard let placemark = placemarks?.first else { return }
            if let _ = error {
                self.showAttentionAlert(message: R.string.localizable.attention_could_not_load_location())
            }
            guard let administrativeArea = placemark.administrativeArea, let locality = placemark.locality, let thoroughfare = placemark.thoroughfare, let subThoroughfare = placemark.subThoroughfare else { return }
            
            if self.isFirstInput {
                self.isFirstInput = false
                return
            }
            self.streetAddressLabel.textColor = .black
            self.streetAddressLabel.text = "\(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)"
            self.streetAddress = "\(administrativeArea)\(locality)\(thoroughfare)\(subThoroughfare)"
        }
    }
}
