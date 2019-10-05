import MapKit
import UIKit

protocol EditNoteUIProtocol: UI {
    
    var memoTextView: PlaceHolderTextView { get }
    var streetAddressLabel: UILabel { get }
    var navBar: UINavigationBar { get }
    var navItem: UINavigationItem { get }
    var saveBtn: UIBarButtonItem { get }
    var cancelBtn: UIBarButtonItem { get }
}

final class EditNoteUI: EditNoteUIProtocol {
    
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
    
    private(set) var statusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .tabbarColor
        return view
    }()
    
    private(set) var navBar: UINavigationBar = {
        let navbar = UINavigationBar()
        return navbar
    }()
    
    private(set) var navItem: UINavigationItem = {
        let navItem = UINavigationItem()
        return navItem
    }()
    
    private(set) var saveBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        return button
    }()
    
    private(set) var cancelBtn: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
        return button
    }()
}

extension EditNoteUI {
    
    func setup() {
        guard let vc = viewController else { return }
        
        vc.view.backgroundColor = .white
        navItem.leftBarButtonItem = cancelBtn
        navItem.rightBarButtonItem = saveBtn
        navBar.pushItem(navItem, animated: true)
        
        [statusBar, navBar, streetAddressLabel, memoTextView].forEach { vc.view.addSubview($0) }
        
        statusBar.anchor()
            .top(to: vc.view.topAnchor)
            .width(constant: vc.view.frame.width)
            .height(constant: 20)
            .activate()
        
        navBar.anchor()
            .top(to: vc.view.safeAreaLayoutGuide.topAnchor)
            .width(constant: vc.view.frame.width)
            .activate()
        
        streetAddressLabel.anchor()
            .centerXToSuperview()
            .top(to: navBar.bottomAnchor)
            .width(constant: vc.view.frame.width * 0.9)
            .height(constant: 35)
            .activate()
        
        memoTextView.anchor()
            .top(to: streetAddressLabel.bottomAnchor, constant: 10)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .bottom(to: vc.view.bottomAnchor)
            .activate()
    }
}
