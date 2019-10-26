import Lottie
import MapKit
import UIKit

protocol CreateMemoUIProtocol: UI {
    
    var memoTextView: PlaceHolderTextView { get }
    var streetAddressLabel: UILabel { get }
    var doneBtn: UIBarButtonItem { get }
    var noteItemsBottomView: NoteItemsBottomView { get }
    var noteItemsView: NoteItemsView { get }
    var noteItemsBtn: UIButton { get }
    var checkAnimationView: AnimationView { get }
    var keyboardHeight: CGFloat { get set }
    
    func changeViewWithKeyboardY(_ bool: Bool, height: CGFloat)
    func transformNoteItemsBtnState(_ isActive: Bool)
    func completeTask(completion: @escaping () -> Void)
}

final class CreateMemoUI: CreateMemoUIProtocol {
    
    weak var viewController: UIViewController?
    
    private let noteItemsHeight: CGFloat = 40.0
    private let percentForRotate: CGFloat = -35.0
    private let noteItemBottomDefaultConstant: CGFloat = 100
    
    private(set) var memoTextView: PlaceHolderTextView = {
        let textview = PlaceHolderTextView()
        textview.layer.borderWidth = 0.5
        textview.layer.borderColor = UIColor.appLightGrey.cgColor
        textview.placeHolder = R.string.localizable.writing_memo()
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()
    
    private(set) var streetAddressLabel: UILabel = {
        let label = UILabel()
        label.apply(.h4)
        label.textAlignment = .center
        return label
    }()
    
    private(set) var doneBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        return button
    }()
    
    private(set) var noteItemsBottomView: NoteItemsBottomView = {
        let view = NoteItemsBottomView()
        view.layer.shadowColor = UIColor.clear.cgColor
        view.itemsStack.layer.shadowColor = UIColor.clear.cgColor
        return view
    }()
    
    private(set) var noteItemsView: NoteItemsView = {
        let view = NoteItemsView()
        view.layer.shadowOpacity = 0
        view.itemsStack.layer.shadowOpacity = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) var noteItemsBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .flatBlue
        button.layer.cornerRadius = 25
        button.setTitle("＋", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.isEnabled = false
        button.alpha = 0
        button.rotate(per: -45)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private(set) lazy var checkAnimationView: AnimationView = {
        guard let vc = viewController else { return AnimationView() }
        let view = AnimationView(name: Constants.Json.check)
        view.center = vc.view.center
        view.loopMode = .playOnce
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 1.2
        view.isHidden = true
        return view
    }()
    
    var memoTextBottomConstarint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    var noteItemBottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    var noteItemBtnBottomConstraint: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    var keyboardHeight: CGFloat = 0.0
}

extension CreateMemoUI {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.navigationItem.rightBarButtonItems = [doneBtn]
        
        [streetAddressLabel, memoTextView, noteItemsBottomView,
         noteItemsView, noteItemsBtn, checkAnimationView].forEach { vc.view.addSubview($0) }
        
        streetAddressLabel.anchor()
            .centerXToSuperview()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor, constant: 10)
            .width(constant: vc.view.frame.width * 0.9)
            .activate()
        
        memoTextBottomConstarint = memoTextView.bottomAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.bottomAnchor,
                                                                        constant: -noteItemsHeight)
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: streetAddressLabel.bottomAnchor, constant: 10),
            memoTextView.leftAnchor.constraint(equalTo: vc.view.leftAnchor),
            memoTextView.rightAnchor.constraint(equalTo: vc.view.rightAnchor),
            memoTextBottomConstarint
        ])
        
        noteItemsBottomView.anchor()
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .bottom(to: vc.view.safeAreaLayoutGuide.bottomAnchor)
            .height(constant: noteItemsHeight)
            .activate()
        
        noteItemBottomConstraint = noteItemsView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor,
                                                                         constant: noteItemBottomDefaultConstant)
        NSLayoutConstraint.activate([
            noteItemsView.heightAnchor.constraint(equalToConstant: noteItemsHeight),
            noteItemsView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            noteItemsView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            noteItemBottomConstraint
        ])

        noteItemBtnBottomConstraint = noteItemsBtn.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor)
        NSLayoutConstraint.activate([
            noteItemsBtn.heightAnchor.constraint(equalToConstant: 50),
            noteItemsBtn.widthAnchor.constraint(equalToConstant: 50),
            noteItemsBtn.rightAnchor.constraint(equalTo: vc.view.rightAnchor, constant: -13),
            noteItemBtnBottomConstraint
        ])
        
        checkAnimationView.anchor()
            .centerToSuperview()
            .width(constant: 40)
            .height(constant: 40)
            .activate()
    }
}

extension CreateMemoUI {
    
    func changeViewWithKeyboardY(_ bool: Bool, height: CGFloat) {
        guard let vc = viewController else { return }
        keyboardHeight = height
        if bool {
            memoTextBottomConstarint.constant = -keyboardHeight - noteItemsHeight
            noteItemBottomConstraint.constant = -keyboardHeight
            noteItemBtnBottomConstraint.constant = -keyboardHeight
        } else {
            noteItemsBtn.isEnabled = false
            noteItemsView.alpha = 1.0
            noteItemsBtn.alpha = 0.0
            noteItemsView.cancelItem.rotate(per: -45)
            noteItemsBtn.rotate(per: percentForRotate)
            memoTextBottomConstarint.constant = -noteItemsHeight
            noteItemBottomConstraint.constant = noteItemBottomDefaultConstant
            noteItemBtnBottomConstraint.constant = 0
        }
        vc.view.layoutIfNeeded()
    }
    
    func transformNoteItemsBtnState(_ isActive: Bool) {
        guard let vc = viewController else { return }
        if isActive {
            noteItemsBtn.isEnabled = true
            UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) { [unowned self] in
                self.noteItemsBtn.rotate(per: 0)
                self.noteItemsView.cancelItem.rotate(per: 0)
                self.noteItemsView.alpha = 0.0
                self.noteItemsBtn.alpha = 1.0
                // height for item bar
                self.noteItemBottomConstraint.constant = -self.keyboardHeight + self.noteItemsHeight
                // height for button
                self.noteItemBtnBottomConstraint.constant = -self.keyboardHeight - self.noteItemsHeight
                // height for textView
                self.memoTextBottomConstarint.constant = -self.keyboardHeight
                vc.view.layoutIfNeeded()
            }.startAnimation()
        } else {
            noteItemsBtn.isEnabled = false
            UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) { [unowned self] in
                self.noteItemsBtn.rotate(per: self.percentForRotate)
                self.noteItemsView.cancelItem.rotate(per: -45)
                self.noteItemsView.alpha = 1.0
                self.noteItemsBtn.alpha = 0.0
                // height for item bar
                self.noteItemBottomConstraint.constant = -self.keyboardHeight
                // height for button
                self.noteItemBtnBottomConstraint.constant = -self.keyboardHeight
                // height for textView
                self.memoTextBottomConstarint.constant = -self.keyboardHeight - self.noteItemsHeight
                vc.view.layoutIfNeeded()
            }.startAnimation()
        }
    }
    
    func completeTask(completion: @escaping () -> Void) {
        checkAnimationView.isHidden = false
        checkAnimationView.play { bool in
            if bool {
                completion()
            }
        }
    }
}
