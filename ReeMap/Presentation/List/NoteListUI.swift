import UIKit

protocol NoteListUIProtocol: UI {
    
    var visualEffectView: UIVisualEffectView { get }
    var searchBar: UISearchBar { get }
    var tableView: UITableView { get }
    
    func changeTableAlpha(_ alpha: CGFloat)
    func setSearchText(fontSize: CGFloat)
    func animateReload()
}

final class NoteListUI: NoteListUIProtocol {
    
    weak var viewController: UIViewController?
    
    private(set) var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 13.0
        view.clipsToBounds = true
        return view
    }()
    
    private(set) var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.showsCancelButton = true
        bar.placeholder = "Search for a your note"
        bar.backgroundImage = UIImage()
        bar.isTranslucent = true
        bar.searchBarStyle = .minimal
        bar.contentMode = .redraw
        bar.showsCancelButton = false
        bar.enablesReturnKeyAutomatically = false
        return bar
    }()
    
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.register(NoteListTableViewCell.self, forCellReuseIdentifier: String(describing: NoteListTableViewCell.self))
        return table
    }()
}

extension NoteListUI {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.addSubview(visualEffectView)
        visualEffectView.contentView.addSubview(tableView)
        visualEffectView.contentView.addSubview(searchBar)
        
        visualEffectView.anchor()
            .top(to: vc.view.topAnchor)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .bottom(to: vc.view.bottomAnchor)
            .activate()
        
        searchBar.anchor()
            .top(to: visualEffectView.contentView.topAnchor, constant: 10)
            .width(constant: vc.view.frame.width)
            .height(constant: 50)
            .activate()
        
        tableView.anchor()
            .top(to: searchBar.bottomAnchor)
            .left(to: visualEffectView.leftAnchor)
            .right(to: visualEffectView.rightAnchor)
            .bottom(to: visualEffectView.bottomAnchor)
            .activate()
        
        setSearchText(fontSize: 15)
    }
    
    func changeTableAlpha(_ alpha: CGFloat) {
        tableView.alpha = alpha
    }
    
    func setSearchText(fontSize: CGFloat) {
        searchBar.setSearchText(fontSize: 15)
    }
    
    func animateReload() {
        UIView.Animator(duration: 0.5)
            .animations { [unowned self] in
                self.tableView.reloadData()
            }.animate()
    }
}
