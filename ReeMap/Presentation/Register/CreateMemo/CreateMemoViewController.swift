import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift
import UIKit

final class CreateMemoViewController: UIViewController {
    
    var memoTextView: PlaceHolderTextView = {
        let textview = PlaceHolderTextView()
        textview.layer.borderWidth = 0.5
        textview.layer.borderColor = UIColor.appLightGrey.cgColor
        textview.placeHolder = R.string.localizable.writing_memo()
        return textview
    }()
    
    var streetAddressLabel: UILabel = {
        let label = UILabel()
        label.apply(.h4)
        label.textAlignment = .center
        return label
    }()
    
    var saveBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        return button
    }()
    
    var cancelBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        return button
    }()
    
    var didRecieveStreetAddress: String! {
        didSet {
            streetAddressLabel.text = didRecieveStreetAddress
        }
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindUI()
    }
}

extension CreateMemoViewController {
    
    func setup() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItems = [saveBtn, cancelBtn]
        
        [streetAddressLabel, memoTextView].forEach { view.addSubview($0) }
        
        streetAddressLabel.anchor()
            .centerXToSuperview()
            .top(to: view.safeAreaLayoutGuide.topAnchor, constant: 10)
            .width(constant: view.frame.width * 0.9)
            .height(constant: 35)
            .activate()
        
        memoTextView.anchor()
            .top(to: streetAddressLabel.bottomAnchor, constant: 10)
            .left(to: view.leftAnchor)
            .right(to: view.rightAnchor)
            .bottom(to: view.bottomAnchor)
            .activate()
    }
    
    func bindUI() {
        
        memoTextView.rx.text.asDriver()
            .drive(onNext: { [unowned self] text in
                guard let text = text else { return }
                self.saveBtn.isEnabled = !text.isEmpty
            }).disposed(by: disposeBag)
        
        saveBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.navigationController?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        cancelBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.showActionSheet(title: R.string.localizable.attention_title(), message: R.string.localizable.attention_missing_info()) { [unowned self] in
                    self.navigationController?.dismiss(animated: true)
                }
            }).disposed(by: disposeBag)
    }
}
