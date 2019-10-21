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
    }
}

extension CreateMemoViewController {
    
    func bindUI() {
        let input = ViewModel.Input(saveBtnTapped: ui.saveBtn.rx.tap.asObservable())
        let output = viewModel?.transform(input: input)
        
        output?.isLoading
            .drive(onNext: { [unowned self] bool in
                self.setIndicator(show: bool)
            }).disposed(by: disposeBag)
        
        output?.isSaveBtnEnable
            .drive(onNext: { [unowned self] bool in
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
        
        ui.memoTextView.rx.text.asDriver()
            .drive(onNext: { [unowned self] text in
                guard let text = text else { return }
                self.ui.saveBtn.isEnabled = !text.isEmpty
                self.viewModel?.setMemoTextView(text)
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
