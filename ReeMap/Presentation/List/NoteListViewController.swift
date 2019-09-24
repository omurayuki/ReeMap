import FloatingPanel
import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol TappedSearchBarDelegate: NSObject {
    
    func tappedSearchBar()
}

extension NoteListViewController: VCInjectable {
    
    typealias UI = NoteListUIProtocol
    typealias Routing = NoteListRoutingProtocol
    typealias ViewModel = NoteListViewModel
    typealias DataSource = TableViewDataSource<NoteListTableViewCell, (String)>
    
    func setupConfig() {
        ui.tableView.dataSource = dataSource
        ui.searchBar.delegate = self
    }
}

class NoteListViewController: UIViewController {
    
    var ui: NoteListUIProtocol! { didSet { ui.viewController = self } }
    var routing: NoteListRoutingProtocol! { didSet { routing.viewController = self } }
    var viewModel: NoteListViewModel!
    var disposeBag: DisposeBag!
    weak var delegate: TappedSearchBarDelegate!
    
    private(set) lazy var dataSource: DataSource = {
        DataSource(cellReuseIdentifier: String(describing: NoteListTableViewCell.self),
                   listItems: [],
                   isSkelton: false,
                   cellConfigurationHandler: { cell, item, _ in
            cell.noteTitle.text = item
            cell.backgroundColor = .clear
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        setupConfig()
        dataSource.listItems = ["hoge", "fuga"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let headerView = ui.tableView.tableHeaderView as? NoteTableHeaderView {
            ui.tableView.tableHeaderView?.frame.size.height = headerView.noteContent.frame.height + 150
            ui.tableView.reloadData()
        }
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
