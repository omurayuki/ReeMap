import UIKit

protocol SideMenuUIProtocol: UI {
    
    var contentView: UIView { get }
    var tableView: UITableView { get }
    var tapGesture: UITapGestureRecognizer { get }
    
    func changeContentRatio(ratio: CGFloat)
}

final class SideMenuUI: SideMenuUIProtocol {
    
    var viewController: UIViewController?
    
    private(set) var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.autoresizingMask = .flexibleHeight
        return view
    }()
    
    private(set) var tableView: UITableView = {
        let table = UITableView()
        table.separatorInset = .zero
        table.register(SideMenuCell.self, forCellReuseIdentifier: String(describing: SideMenuCell.self))
        return table
    }()
    
    private(set) var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        return gesture
    }()
}

extension SideMenuUI {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.addSubview(contentView)
        contentView.addSubview(tableView)
        vc.view.addGestureRecognizer(tapGesture)
        
        var contentRect = vc.view.bounds
        contentRect.size.width = vc.view.bounds.width * 0.6
        contentRect.origin.x = -contentRect.width
        contentView.frame = contentRect
        tableView.frame = contentView.bounds
    }
    
    func changeContentRatio(ratio: CGFloat) {
        guard let vc = viewController else { return }
        let ratio = min(max(ratio, 0), 1)
        contentView.frame.origin.x = vc.view.bounds.width * 0.6 * ratio - contentView.frame.width
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowRadius = 3.0
        contentView.layer.shadowOpacity = 0.6
        vc.view.backgroundColor = UIColor(white: 0, alpha: 0.3 * ratio)
    }
}
