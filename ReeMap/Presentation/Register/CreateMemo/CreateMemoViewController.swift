import CoreLocation
import FirebaseFirestore
import Foundation
import MapKit
import RxCocoa
import RxSwift
import UIKit

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
    
    override func loadView() {
        super.loadView()
        ui.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        setupConfig()
    }
}

extension CreateMemoViewController {
    
    func bindUI() {
        let input = ViewModel.Input()
        let output = viewModel?.transform(input: input)
        
        output?.isLoading
            .drive(onNext: { [unowned self] bool in
                self.setIndicator(show: bool)
            }).disposed(by: disposeBag)
        
        output?.isSaveBtnEnable
            .drive(onNext: { bool in
                self.ui.saveBtn.isEnabled = bool
            }).disposed(by: disposeBag)
        
        ui.memoTextView.rx.text.asDriver()
            .drive(onNext: { [unowned self] text in
                guard let text = text else { return }
                self.ui.saveBtn.isEnabled = !text.isEmpty
            }).disposed(by: disposeBag)
        
        ui.saveBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.getPlacemarks(streetAddress: self.ui.streetAddressLabel.text ?? "") { [unowned self] latitude, longitude in
                    self.setNote(self.createEntity(latitude: latitude, longitude: longitude), completion: { [unowned self] in
                        self.routing?.dismiss()
                    })
                }
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

extension CreateMemoViewController {
    
    private func getPlacemarks(streetAddress: String, completion: @escaping (Double, Double) -> Void) {
        viewModel?.getPlacemarks(streetAddress: streetAddress)
            .subscribe(onSuccess: { placemark in
                completion(placemark.location?.coordinate.latitude ?? 0.0, placemark.location?.coordinate.longitude ?? 0.0)
            }, onError: { [unowned self] _ in
                self.showError(message: R.string.localizable.could_not_get())
            }).disposed(by: disposeBag)
    }
    
    private func setNote(_ note: EntityType, completion: @escaping () -> Void) {
        viewModel?.updateLoading(true)
        viewModel?.setSaveBtnEnable(false)
        viewModel?.setNote(note)
            .subscribe(onSuccess: { _ in
                self.viewModel?.updateLoading(false)
                self.viewModel?.setSaveBtnEnable(true)
                completion()
            }, onError: { [unowned self] _ in
                self.viewModel?.updateLoading(false)
                self.viewModel?.setSaveBtnEnable(true)
                self.showError(message: R.string.localizable.error_message_network())
            }).disposed(by: disposeBag)
    }
    
    private func createEntity(latitude: Double, longitude: Double) -> EntityType {
        guard let uid = viewModel?.getUIDToken() else { return [:] }
        return [
            "uid": uid,
            "created_at": FieldValue.serverTimestamp(),
            "updated_at": FieldValue.serverTimestamp(),
            "content": ui.memoTextView.text ?? "",
            "notification": true,
            "street_addresss": ui.streetAddressLabel.text ?? "",
            "geo_point": GeoPoint(latitude: latitude, longitude: longitude)
        ]
    }
}
