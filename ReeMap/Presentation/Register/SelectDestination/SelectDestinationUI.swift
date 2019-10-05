import MapKit
import UIKit

protocol SelectDestinationUIProtocol: UI {
    
    var mapView: MKMapView { get }
    var selectImage: UIImageView { get }
    var streetAddressLabel: UILabel { get }
    var tapGesture: UITapGestureRecognizer { get }
    var settingsBtn: UIButton { get }
    var cancelBtn: UIButton { get }
    
    func changeSettingsBtnState(bool: Bool)
    func setStreetAddress(_ address: String)
}

final class SelectDestinationUI: SelectDestinationUIProtocol {
    
    weak var viewController: UIViewController?
    
    private(set) var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = false
        mapView.showsCompass = false
        mapView.showsScale = false
        return mapView
    }()
    
    private(set) var selectImage: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "pinMark"))
        image.clipsToBounds = true
        image.layer.cornerRadius = 17.5
        return image
    }()
    
    private(set) var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
    }()
    
    private(set) var streetAddressLabel: UILabel = {
        let label = UILabel()
        label.apply(.h5)
        label.textAlignment = .center
        label.backgroundColor = .appLightGrey
        label.layer.cornerRadius = 2
        label.textColor = .gray
        label.text = R.string.localizable.trace_map()
        label.isUserInteractionEnabled = true
        label.clipsToBounds = true
        return label
    }()
    
    private(set) var arrowIcon: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "arrow")
        image.clipsToBounds = true
        image.backgroundColor = .clear
        return image
    }()
    
    private(set) var settingsBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .flatBlue
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
        button.backgroundColor = .flatRed
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
        streetAddressLabel.addGestureRecognizer(tapGesture)
        mapView.addSubview(selectImage)
        streetAddressLabel.addSubview(arrowIcon)
        
        mapView.anchor()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .bottom(to: streetAddressLabel.topAnchor, constant: -25)
            .activate()
        
        selectImage.anchor()
            .centerToSuperview()
            .width(constant: 35)
            .height(constant: 35)
            .activate()
        
        streetAddressLabel.anchor()
            .centerXToSuperview()
            .bottom(to: stack.topAnchor, constant: -20)
            .width(constant: vc.view.frame.width * 0.9)
            .height(constant: 45)
            .activate()
        
        arrowIcon.anchor()
            .centerYToSuperview()
            .right(to: streetAddressLabel.rightAnchor, constant: -5)
            .width(constant: 35)
            .height(constant: 35)
            .activate()
        
        stack.anchor()
            .centerXToSuperview()
            .bottom(to: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
            .activate()
        
        settingsBtn.anchor()
            .bottom(to: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
            .width(constant: vc.view.frame.width / 2 * 0.9)
            .height(constant: 45)
            .activate()
        
        cancelBtn.anchor()
            .bottom(to: vc.view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
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
    
    func setStreetAddress(_ address: String) {
        streetAddressLabel.textColor = .black
        streetAddressLabel.text = address
    }
}
