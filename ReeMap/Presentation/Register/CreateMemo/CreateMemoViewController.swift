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
                self.viewModel?.setMemoText(self.ui.memoTextView.attributedText.string)
            }).disposed(by: disposeBag)
        
        ui.memoTextView.rx.text.asDriver()
            .debounce(1.0)
            .drive(onNext: { text in
                guard let text = text else { return }
                guard !text.isEmpty else { return }
                
            }).disposed(by: disposeBag)
        
        ui.noteItemsBottomView.deleteItem.rx.tap.asDriver()
            .drive(onNext: { _ in
                // 画像を全て配列で取得 可能
                let images = self.ui.memoTextView.getImages()
                // 画像の行番を配列で取得 可能
                let lineNum = self.ui.memoTextView.getParts()
                    .enumerated()
                    .compactMap { index, object -> Int? in
                    guard let _ = object as? UIImage else { return nil }
                    return index
                }
                // テキストデータとしてattributeStringを取得(画像データはfirestoreで特殊文字列に変換されるけど大丈夫)
                let text = self.ui.memoTextView.attributedText.string
                // 取得したimageをstorageに保存 URLを取得 data層で
                // URL, 行番, テキストをfirestoreに保存 data層で
                
                /// viewmodelにpoost用のstoredpropertyが多くなるから、structで作成 edit画面でもいくつか同一のデータをpostするから公開用のprotocolを作成
                /// viewmodelの責務としてデータの入出力とviewに渡すデータの加工がある だから画像を保存先にして、そしてデータを保存するみたいなdata層のための加工?はやらない
//                guard let htmlString = self.ui.memoTextView.attributedText.convertHTML() else { return }
//                guard let image = self.ui.memoTextView.getParts()[0] as? UIImage else { return }
//                let vc = SampleVC(text: image)
//                self.present(vc, animated: true)
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
