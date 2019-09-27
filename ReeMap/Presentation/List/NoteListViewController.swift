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
    typealias DataSource = TableViewDataSource<NoteListTableViewCell, Place>
    
    func setupConfig() {
        ui.tableView.dataSource = dataSource
        ui.tableView.delegate = self
        ui.searchBar.delegate = self
    }
}

class NoteListViewController: UIViewController {
    
    var ui: NoteListUIProtocol! { didSet { ui.viewController = self } }
    var routing: NoteListRoutingProtocol? { didSet { routing?.viewController = self } }
    var viewModel: NoteListViewModel?
    var disposeBag: DisposeBag!
    weak var delegate: TappedSearchBarDelegate!
    
    var didAcceptPlaces: [Place]? {
        didSet {
            guard let places = didAcceptPlaces else { return }
            dataSource.listItems = places
            ui.tableView.reloadData()
        }
    }
    
    private(set) lazy var dataSource: DataSource = {
        DataSource(cellReuseIdentifier: String(describing: NoteListTableViewCell.self),
                   listItems: [],
                   cellConfigurationHandler: { cell, item, _ in
            cell.didPlaceUpdated = item
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        setupConfig()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ui.hideHeader()
    }
}

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ui.changeTableAlpha(0.9)
        ui.showHeader()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .normal, title: R.string.localizable.delete()) { [unowned self] _, _ in
            self.dataSource.listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = .red
        return [deleteButton]
    }
}

// searchBar rxで描きたい
extension NoteListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        delegate.tappedSearchBar()
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ui.showHeader()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        ui.hideHeader()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}
