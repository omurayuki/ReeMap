import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift
import UIKit
import Firebase
import FirebaseFirestore

extension CreateMemoViewController: VCInjectable {
    
    typealias UI = CreateMemoUIProtocol
    typealias Routing = CreateMemoRoutingProtocol
    typealias ViewModel = CreateMemoViewModel
    
    func setupConfig() {}
}

final class CreateMemoViewController: UIViewController {
    
    var ui: CreateMemoUIProtocol! { didSet { ui.viewController = self } }
    var routing: CreateMemoRoutingProtocol? { didSet { routing?.viewController = self } }
    var viewModel: CreateMemoViewModel?
    var disposeBag: DisposeBag!
    
    var didRecieveStreetAddress: String? {
        didSet {
            ui.streetAddressLabel.text = didRecieveStreetAddress
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        bindUI()
        setupConfig()
    }
}

extension CreateMemoViewController {
    
    func bindUI() {
        ui.memoTextView.rx.text.asDriver()
            .drive(onNext: { [unowned self] text in
                guard let text = text else { return }
                self.ui.saveBtn.isEnabled = !text.isEmpty
            }).disposed(by: disposeBag)
        
        ui.saveBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                var latitude: Double = 0.0
                var longitude: Double = 0.0
                CLGeocoder().geocodeAddressString(self.ui.streetAddressLabel.text ?? "", completionHandler: { placemark, error in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    latitude = placemark?.first?.location?.coordinate.latitude ?? 0.0
                    longitude = placemark?.first?.location?.coordinate.longitude ?? 0.0
                    guard let uid = AppUserDefaultsUtils.getUIDToken() else { return }
                    Firestore.firestore().collection("Users").document(uid).collection("Notes").document().setData(["uid": uid, "created_at": FieldValue.serverTimestamp(), "updated_at": FieldValue.serverTimestamp(), "content": self.ui.memoTextView.text ?? "", "notification": true, "geo_point": GeoPoint(latitude: latitude, longitude: longitude)], completion: { error in
                        if let _ = error {
                            print("保存できませんでした")
                            return
                        }
                        self.routing?.dismiss()
                    })
                })
            }).disposed(by: disposeBag)
        
        ui.cancelBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.showActionSheet(title: R.string.localizable.attention_title(),
                                     message: R.string.localizable.attention_missing_info()) { [unowned self] in
                    self.routing?.dismiss()
                }
            }).disposed(by: disposeBag)
    }
}
