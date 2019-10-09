import CoreLocation
import FirebaseFirestore
import Foundation
import MapKit
import RxCocoa
import RxSwift
import UIKit

extension EditNoteViewController: VCInjectable {
    
    typealias UI = EditNoteUIProtocol
    typealias Routing = EditNoteRoutingProtocol
    typealias ViewModel = EditNoteViewModel
    
    func setupConfig() {
    }
}

final class EditNoteViewController: UIViewController {
    
    var ui: EditNoteUIProtocol! { didSet { ui.viewController = self } }
    var routing: EditNoteRoutingProtocol? { didSet { routing?.viewController = self } }
    var viewModel: EditNoteViewModel?
    var disposeBag: DisposeBag!
    
    var didRecieveNoteId: String!
    
    var didRecieveStreetAddress: String? {
        didSet {
            ui.streetAddressLabel.text = didRecieveStreetAddress
        }
    }
    
    var didRecieveNote: String? {
        didSet {
            ui.memoTextView.insertText(didRecieveNote ?? "")
        }
    }
    
    override func loadView() {
        super.loadView()
        ui.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        bindUI()
    }
}

extension EditNoteViewController {
    
    private func bindUI() {
        ui.cancelBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.showActionSheet(title: R.string.localizable.attention_title(),
                                     message: R.string.localizable.attension_edit_message(),
                                     completion: { [unowned self] in
                    self.routing?.dismiss()
                })
            }).disposed(by: disposeBag)
        
        ui.memoTextView.rx.text.asDriver()
            .drive(onNext: { [unowned self] text in
                guard let text = text else { return }
                self.ui.saveBtn.isEnabled = !text.isEmpty
            }).disposed(by: disposeBag)
        
        ui.saveBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.getPlacemarks(streetAddress: self.ui.streetAddressLabel.text ?? "",
                                   completion: { [unowned self] latitude, longitude in
                    self.updateNote(self.createEntity(latitude: latitude, longitude: longitude), completion: { [unowned self] in
                        self.routing?.dismiss()
                    })
                })
            }).disposed(by: disposeBag)
    }
}

extension EditNoteViewController {
    
    private func getPlacemarks(streetAddress: String, completion: @escaping (Double, Double) -> Void) {
        viewModel?.getPlacemarks(streetAddress: streetAddress)
            .subscribe(onSuccess: { placemark in
                completion(placemark.location?.coordinate.latitude ?? 0.0, placemark.location?.coordinate.longitude ?? 0.0)
            }, onError: { [unowned self] _ in
                self.showError(message: R.string.localizable.could_not_get())
            }).disposed(by: disposeBag)
    }
    
    private func updateNote(_ note: EntityType, completion: @escaping () -> Void) {
        guard let docId = didRecieveNoteId else { return }
        viewModel?.updateNote(note, noteId: docId)
            .subscribe(onSuccess: { _ in
                completion()
            }, onError: { error in
                self.showError(message: R.string.localizable.error_message_network())
            }).disposed(by: self.disposeBag)
    }
    
    private func createEntity(latitude: Double, longitude: Double) -> EntityType {
        return [
            Constants.DictKey.updatedAt: FieldValue.serverTimestamp(),
            Constants.DictKey.content: self.ui.memoTextView.text ?? "",
            Constants.DictKey.notification: true,
            Constants.DictKey.geoPoint: GeoPoint(latitude: latitude,
                                                 longitude: longitude)
        ]
    }
}
