import FloatingPanel
import Foundation
import UIKit

protocol TappedSearchBarDelegate: NSObject {
    
    func tappedSearchBar()
}

class NoteListViewController: UIViewController {
    
    weak var delegate: TappedSearchBarDelegate!
    
    var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 13.0
        view.clipsToBounds = true
        return view
    }()
    
    var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.showsCancelButton = true
        bar.placeholder = "Search for a your note"
        bar.backgroundImage = UIImage()
        bar.isTranslucent = true
        bar.searchBarStyle = .minimal
        bar.contentMode = .redraw
        bar.showsCancelButton = false
        return bar
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.register(NoteListTableViewCell.self, forCellReuseIdentifier: String(describing: NoteListTableViewCell.self))
        return table
    }()
    
    var header: NoteTableHeaderView = {
        let view = NoteTableHeaderView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        setup()
        searchBar.setSearchText(fontSize: 15)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let headerView = tableView.tableHeaderView as? NoteTableHeaderView {
            tableView.tableHeaderView?.frame.size.height = headerView.noteContent.frame.height + 150
            tableView.reloadData()
        }
    }
    
    func setup() {
        view.addSubview(visualEffectView)
        visualEffectView.contentView.addSubview(tableView)
        visualEffectView.contentView.addSubview(searchBar)
        tableView.tableHeaderView = header
        
        visualEffectView.anchor()
            .top(to: view.topAnchor)
            .left(to: view.leftAnchor)
            .right(to: view.rightAnchor)
            .bottom(to: view.bottomAnchor)
            .activate()
        
        searchBar.anchor()
            .top(to: visualEffectView.contentView.topAnchor, constant: 10)
            .width(constant: view.frame.width)
            .height(constant: 50)
            .activate()
        
        tableView.anchor()
            .top(to: searchBar.bottomAnchor)
            .left(to: visualEffectView.leftAnchor)
            .right(to: visualEffectView.rightAnchor)
            .bottom(to: visualEffectView.bottomAnchor)
            .activate()
    }
    
    func changeTableAlpha(_ alpha: CGFloat) {
        tableView.alpha = alpha
    }
}

extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoteListTableViewCell.self),
                                                     for: indexPath) as? NoteListTableViewCell
        else { return UITableViewCell() }
        cell.backgroundColor = .clear
        return cell
    }
}

extension NoteListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        delegate.tappedSearchBar()
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}

extension UISearchBar {
    func setSearchText(fontSize: CGFloat) {
        #if swift(>=5.1)
        let font = searchTextField.font
        searchTextField.font = font?.withSize(fontSize)
        #else
        guard let textField = value(forKey: "_searchField") as? UITextField else { return }
        textField.font = textField.font?.withSize(fontSize)
        #endif
    }
}
