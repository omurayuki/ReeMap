import MapKit
import UIKit

protocol CreateMemoUIProtocol: UI {
    
    var memoTextView: PlaceHolderTextView { get }
    var streetAddressLabel: UILabel { get }
    var saveBtn: UIBarButtonItem { get }
    var cancelBtn: UIBarButtonItem { get }
    var noteItemsBottomView: NoteItemsBottomView { get }
}

final class CreateMemoUI: CreateMemoUIProtocol {
    
    weak var viewController: UIViewController?
    
    private(set) var memoTextView: PlaceHolderTextView = {
        let textview = PlaceHolderTextView()
        textview.layer.borderWidth = 0.5
        textview.layer.borderColor = UIColor.appLightGrey.cgColor
        textview.placeHolder = R.string.localizable.writing_memo()
        return textview
    }()
    
    private(set) var streetAddressLabel: UILabel = {
        let label = UILabel()
        label.apply(.h4)
        label.textAlignment = .center
        return label
    }()
    
    private(set) var saveBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        return button
    }()
    
    private(set) var cancelBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        return button
    }()
    
    private(set) var noteItemsBottomView: NoteItemsBottomView = {
        let view = NoteItemsView()
        return view
    }()
}

extension CreateMemoUI {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.navigationItem.rightBarButtonItems = [saveBtn, cancelBtn]
        
        [streetAddressLabel, memoTextView, noteItemsBottomView].forEach { vc.view.addSubview($0) }
        
        streetAddressLabel.anchor()
            .centerXToSuperview()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor, constant: 10)
            .width(constant: vc.view.frame.width * 0.9)
            .activate()
        
        memoTextView.anchor()
            .top(to: streetAddressLabel.bottomAnchor, constant: 10)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .activate()
        
        noteItemsBottomView.anchor()
            .top(to: memoTextView.bottomAnchor)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .bottom(to: vc.view.safeAreaLayoutGuide.bottomAnchor)
            .height(constant: 40)
            .activate()
    }
}
