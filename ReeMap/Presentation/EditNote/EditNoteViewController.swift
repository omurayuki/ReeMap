import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift
import UIKit

extension EditNoteViewController: VCInjectable {
    
    typealias UI = EditNoteUIProtocol
    typealias Routing = EditNoteRoutingProtocol
    typealias ViewModel = EditNoteViewModel
    
    func setupConfig() {}
}

final class EditNoteViewController: UIViewController {
    
    var ui: EditNoteUIProtocol! { didSet { ui.viewController = self } }
    var routing: EditNoteRoutingProtocol? { didSet { routing?.viewController = self } }
    var viewModel: EditNoteViewModel?
    var disposeBag: DisposeBag!
    
    override func loadView() {
        super.loadView()
        ui.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        bindUI()
        setUIData()
    }
}

extension EditNoteViewController {
    
    private func bindUI() {
        let input = ViewModel.Input(saveBtnTapped: ui.saveBtn.rx.tap.asObservable())
        let output = viewModel?.transform(input: input)
        
        output?.isLoading
            .drive(onNext: { [unowned self] bool in
                self.setIndicator(show: bool)
            }).disposed(by: disposeBag)
        
        output?.isSaveBtnEnable
            .drive(onNext: { bool in
                self.ui.saveBtn.isEnabled = bool
            }).disposed(by: disposeBag)
        
        output?.noteSaveSuccess
            .subscribe(onNext: { [unowned self] _ in
                self.routing?.dismiss()
                self.viewModel?.updateLoading(false)
                self.viewModel?.setSaveBtnEnable(true)
            }).disposed(by: disposeBag)
        
        output?.noteSaveError
            .subscribe(onNext: { [unowned self] _ in
                self.viewModel?.updateLoading(false)
                self.viewModel?.setSaveBtnEnable(true)
                self.showError(message: R.string.localizable.error_message_network())
            }).disposed(by: disposeBag)
        
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
                self.viewModel?.setTextData(text)
            }).disposed(by: disposeBag)
    }
}

extension EditNoteViewController {
    
    private func setUIData() {
        viewModel?.streetAddressRecieveHandler = { [unowned self] streetAddress in
            self.ui.streetAddressLabel.text = streetAddress
        }
        
        viewModel?.noteRecieveHandler = { [unowned self] note in
            self.ui.memoTextView.insertText(note)
        }
    }
}
