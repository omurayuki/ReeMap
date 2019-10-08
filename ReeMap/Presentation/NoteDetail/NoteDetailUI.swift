import UIKit

protocol NoteDetailUIProtocol: UI {
    
    var visualEffectView: UIVisualEffectView { get }
    var tableView: UITableView { get }
}

final class NoteDetailUI: NoteDetailUIProtocol {
    
    var viewController: UIViewController?
    
    private(set) var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 13.0
        view.clipsToBounds = true
        return view
    }()
    
    private(set) var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.allowsSelection = false
        table.register(NoteDetailCell.self, forCellReuseIdentifier: String(describing: NoteDetailCell.self))
        return table
    }()
}

extension NoteDetailUI {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.addSubview(visualEffectView)
        visualEffectView.contentView.addSubview(tableView)
        
        visualEffectView.anchor()
            .top(to: vc.view.topAnchor)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .bottom(to: vc.view.bottomAnchor)
            .activate()
        
        tableView.anchor()
            .edgesToSuperview()
            .activate()
    }
}
