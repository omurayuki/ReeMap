import MapKit
import UIKit

protocol CreateMemoUIProtocol: UI {
    
    var memoTextView: PlaceHolderTextView { get }
    var streetAddressLabel: UILabel { get }
    var saveBtn: UIBarButtonItem { get }
    var cancelBtn: UIBarButtonItem { get }
    var noteItemsBottomView: NoteItemsBottomView { get }
    var noteItemsView: NoteItemsView { get }
    var noteItemsBtn: UIButton { get }
    var noteItemBottomConstraint: NSLayoutConstraint { get set }
    var keyboardHeight: CGFloat { get set }
    
    func changeViewWithKeyboardY(_ bool: Bool, height: CGFloat)
    func transformNoteItemsBtnState(_ isActive: Bool)
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
        let view = NoteItemsBottomView()
        return view
    }()
    
    private(set) var noteItemsView: NoteItemsView = {
        let view = NoteItemsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) var noteItemsBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.isEnabled = false
        button.alpha = 0
        button.transform = CGAffineTransform(rotationAngle: CGFloat(-35 * CGFloat.pi / 180))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var noteItemBottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    var noteItemBtnBottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    var noteItemBtnRightConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    var keyboardHeight: CGFloat = 0.0
}

extension CreateMemoUI {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.navigationItem.rightBarButtonItems = [saveBtn, cancelBtn]
        
        [streetAddressLabel, memoTextView, noteItemsBottomView, noteItemsView, noteItemsBtn].forEach { vc.view.addSubview($0) }
        
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
        
        noteItemBottomConstraint = noteItemsView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor, constant: 100)
        NSLayoutConstraint.activate([
            noteItemsView.heightAnchor.constraint(equalToConstant: 40),
            noteItemsView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            noteItemsView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            noteItemBottomConstraint
        ])

        noteItemBtnRightConstraint = noteItemsBtn.rightAnchor.constraint(equalTo: vc.view.rightAnchor)
        noteItemBtnBottomConstraint = noteItemsBtn.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
        NSLayoutConstraint.activate([
            noteItemsBtn.heightAnchor.constraint(equalToConstant: 50),
            noteItemsBtn.widthAnchor.constraint(equalToConstant: 50),
            noteItemBtnRightConstraint,
            noteItemBtnBottomConstraint
        ])
    }
}

extension CreateMemoUI {
    
    func changeViewWithKeyboardY(_ bool: Bool, height: CGFloat) {
        guard let vc = viewController else { return }
        keyboardHeight = height
        if bool {
            noteItemBottomConstraint.constant = -keyboardHeight
            noteItemBtnBottomConstraint.constant = -keyboardHeight
        } else {
            noteItemsBtn.isEnabled = false
            noteItemsBtn.alpha = 0.0
            noteItemBottomConstraint.constant = 100
            noteItemBtnBottomConstraint.constant = 0
        }
        vc.view.layoutIfNeeded()
    }
    
    func transformNoteItemsBtnState(_ isActive: Bool) {
        guard let vc = viewController else { return }
        if isActive {
            self.noteItemsBtn.isEnabled = true
            UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) { [unowned self] in
                self.noteItemsBtn.transform = CGAffineTransform(rotationAngle: CGFloat(0 * CGFloat.pi / 180))
                self.noteItemsBtn.alpha = 1.0
                // height for item bar
                self.noteItemBottomConstraint.constant = -self.keyboardHeight + 40
                // height for button
                self.noteItemBtnBottomConstraint.constant = -self.keyboardHeight - 40
                self.noteItemBtnRightConstraint.constant = -10
                vc.view.layoutIfNeeded()
            }.startAnimation()
        } else {
            self.noteItemsBtn.isEnabled = false
            UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) { [unowned self] in
                self.noteItemsBtn.transform = CGAffineTransform(rotationAngle: CGFloat(-35 * CGFloat.pi / 180))
                self.noteItemsBtn.alpha = 0.0
                // height for item bar
                self.noteItemBottomConstraint.constant = -self.keyboardHeight
                // height for button
                self.noteItemBtnBottomConstraint.constant = -self.keyboardHeight
                self.noteItemBtnRightConstraint.constant = 0
                vc.view.layoutIfNeeded()
            }.startAnimation()
        }
    }
}
