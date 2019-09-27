import MapKit
import UIKit

protocol SelectDestinationUIProtocol: UI {
    
    var mapView: MKMapView { get }
    var selectImage: UIImageView { get }
    var streetAddressLabel: UILabel { get }
    var settingsBtn: UIButton { get }
    var cancelBtn: UIButton { get }
    
    func changeSettingsBtnState(bool: Bool)
}

final class SelectDestinationUI: SelectDestinationUIProtocol {
    
    var viewController: UIViewController?
    
    private(set) var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = false
        mapView.showsCompass = false
        mapView.showsScale = false
        return mapView
    }()
    
    private(set) var selectImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .green
        image.clipsToBounds = true
        image.layer.cornerRadius = 17.5
        return image
    }()
    
    private(set) var streetAddressLabel: UILabel = {
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
    
    private(set) var settingsBtn: UIButton = {
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
    
    private(set) var cancelBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.setTitle(R.string.localizable.frame_selected_action_sheet_cancel(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
}

extension SelectDestinationUI {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.navigationItem.title = R.string.localizable.select_destination()
        vc.view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [
            settingsBtn,
            cancelBtn
            ])
        stack.spacing = 20
        
        [mapView, streetAddressLabel, stack].forEach { vc.view.addSubview($0) }
        mapView.addSubview(selectImage)
        
        mapView.anchor()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .height(constant: vc.view.frame.height * 0.5)
            .activate()
        
        selectImage.anchor()
            .centerToSuperview()
            .width(constant: 35)
            .height(constant: 35)
            .activate()
        
        streetAddressLabel.anchor()
            .centerXToSuperview()
            .top(to: mapView.bottomAnchor, constant: 30)
            .width(constant: vc.view.frame.width * 0.9)
            .height(constant: 45)
            .activate()
        
        stack.anchor()
            .centerXToSuperview()
            .top(to: streetAddressLabel.bottomAnchor, constant: 25)
            .activate()
        
        settingsBtn.anchor()
            .top(to: streetAddressLabel.bottomAnchor, constant: 25)
            .width(constant: vc.view.frame.width / 2 * 0.9)
            .height(constant: 45)
            .activate()
        
        cancelBtn.anchor()
            .top(to: streetAddressLabel.bottomAnchor, constant: 25)
            .width(constant: vc.view.frame.width / 2 * 0.9)
            .height(constant: 45)
            .activate()
    }
}

extension SelectDestinationUI {
    
    func changeSettingsBtnState(bool: Bool) {
        bool ? (settingsBtn.alpha = CGFloat(1.0)) : (settingsBtn.alpha = CGFloat(0.2))
        settingsBtn.isEnabled = bool
    }
}
