import CoreLocation
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
    
    var keyboardNotifier: KeyboardNotifier! = KeyboardNotifier()
    
    var imagePickerService = ImagePickerService()
    
    var didRecieve: String? {
        didSet {
            self.ui.streetAddressLabel.text = didRecieve
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
        listenKeyboard(keyboardNotifier: keyboardNotifier)
    }
}

extension CreateMemoViewController {
    
    func bindUI() {
        let input = ViewModel.Input(noteItemBottomSaveBtnTapped: ui.noteItemsBottomView.saveItem.rx.tap.asObservable(),
                                    noteItemSaveBtnTapped: ui.noteItemsView.saveItem.rx.tap.asObservable())
        let output = viewModel?.transform(input: input)
        
        output?.isLoading
            .drive(onNext: { [unowned self] bool in
                self.setIndicator(show: bool)
            }).disposed(by: disposeBag)
        
        output?.isSaveBtnEnable
            .drive(onNext: { [unowned self] bool in
                [self.ui.noteItemsView.saveItem, self.ui.noteItemsBottomView.saveItem].forEach {
                    $0.isEnabled = bool
                }
            }).disposed(by: disposeBag)
        
        output?.noteItemBottomSaveSuccess
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel?.updateLoading(false) { [unowned self] in
                    self.ui.completeTask { [unowned self] in
                        self.routing?.dismiss()
                    }
                }
                self.viewModel?.setSaveBtnEnable(true)
            }).disposed(by: disposeBag)
        
        output?.noteItemBottomSaveError
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel?.updateLoading(false)
                self.viewModel?.setSaveBtnEnable(true)
                self.showError(message: R.string.localizable.error_message_network())
            }).disposed(by: disposeBag)
        
        output?.noteItemSaveSuccess
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel?.updateLoading(false) { [unowned self] in
                    self.ui.completeTask { [unowned self] in
                        self.routing?.dismiss()
                    }
                }
                self.viewModel?.setSaveBtnEnable(true)
            }).disposed(by: disposeBag)
        
        output?.noteItemSaveError
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel?.updateLoading(false)
                self.viewModel?.setSaveBtnEnable(true)
                self.showError(message: R.string.localizable.error_message_network())
            }).disposed(by: disposeBag)
        
        ui.doneBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.ui.memoTextView.resignFirstResponder()
            }).disposed(by: disposeBag)

        ui.memoTextView.rx.text.asDriver()
            .drive(onNext: { [unowned self] text in
                guard let text = text else { return }
                [self.ui.noteItemsView.saveItem, self.ui.noteItemsBottomView.saveItem].forEach {
                    $0.isEnabled = !text.isEmpty
                }
                self.viewModel?.setMemoTextView(text)
            }).disposed(by: disposeBag)
        
        ui.noteItemsBottomView.deleteItem.rx.tap.asDriver()
            .drive(onNext: { _ in
                print("delete以外のもので何か考える")
            }).disposed(by: disposeBag)
        
        [ui.noteItemsBottomView.cameraItem, ui.noteItemsView.cameraItem].forEach {
            $0.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.imagePickerService.pickImage(from: self, allowEditing: true, source: nil) { [unowned self] result in
                        switch result {
                        case .success(let image):
                            self.ui.memoTextView.addImage(image: image)
                            image.savedPhotosAlbum()
                        case .failure(_):
                            self.showError(message: R.string.localizable.failure_load_document())
                        }
                    }
                }).disposed(by: disposeBag)
        }
        
        [ui.noteItemsBottomView.writeItem, ui.noteItemsView.writeItem].forEach {
            $0.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.ui.memoTextView.becomeFirstResponder()
                }).disposed(by: disposeBag)
        }
        
        [ui.noteItemsView.returnItem, ui.noteItemsBottomView.returnItem].forEach {
            $0.rx.tap.asDriver()
                .drive(onNext: { [unowned self] _ in
                    self.showActionSheet(title: R.string.localizable.attention_title(),
                                         message: R.string.localizable.attention_missing_info()) { [unowned self] in
                        self.routing?.dismiss()
                    }
                }).disposed(by: disposeBag)
        }
            
        ui.noteItemsView.cancelItem.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.ui.transformNoteItemsBtnState(true)
            }).disposed(by: disposeBag)

        ui.noteItemsBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.ui.transformNoteItemsBtnState(false)
            }).disposed(by: disposeBag)
    }
}

extension CreateMemoViewController: KeyboardListener {
    
    func keyboardPresent(_ height: CGFloat) {
        ui.changeViewWithKeyboardY(true, height: height)
    }
    
    func keyboardDismiss(_ height: CGFloat) {
        ui.changeViewWithKeyboardY(false, height: height)
    }
}
