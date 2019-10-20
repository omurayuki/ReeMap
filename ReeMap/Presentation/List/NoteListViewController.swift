import CoreLocation
import FloatingPanel
import Foundation
import RxCocoa
import RxSwift
import UIKit

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
    
    weak var tappedSearchBarDelegate: TappedSearchBarDelegate!
    weak var tappedCellDelegate: TappedCellDelegate!
    
    // MARK: UITableViewDataSource
    
    private(set) lazy var dataSource: DataSource = {
        DataSource(cellReuseIdentifier: String(describing: NoteListTableViewCell.self),
                   listItems: [],
                   cellConfigurationHandler: { cell, item, _ in
            cell.docId = item.documentId
            cell.delegate = self
            cell.didPlaceUpdated = item
        })
    }()
    
    override func loadView() {
        super.loadView()
        ui.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        bindUI()
        viewModel?.placeAcceptHandler = { [unowned self] places in
            self.dataSource.listItems = places
            self.viewModel?.places = places
            self.ui.tableView.reloadData()
        }
    }
}

extension NoteListViewController {
    
    private func bindUI() {
        let input = ViewModel.Input(switchNotification: rx.sentMessage(#selector(switchNotification(_:docId:))).asObservable(),
                                    deleteRows: rx.sentMessage(#selector(deleteRows(indexPath:))).asObservable())
        let output = viewModel?.transform(input: input)
        
        output?.notificationError
            .subscribe(onNext: { [unowned self] _ in
                self.showError(message: R.string.localizable.error_message_network())
            }).disposed(by: disposeBag)
        
        output?.deleteError
            .subscribe(onNext: { [unowned self] _ in
                self.showError(message: R.string.localizable.could_not_delete())
            }).disposed(by: disposeBag)
    }
}

extension NoteListViewController {
    
    @objc private func deleteRows(indexPath: IndexPath) {}
}

// MARK: UITableViewDelegate

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tappedCellDelegate.didselectCell(place: dataSource.listItems[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .normal, title: R.string.localizable.delete()) { [unowned self] _, _ in
            //// didEndEditingRowAtで使用するため、一旦コピー
            self.viewModel?.placesForDeletion = self.dataSource.listItems
            self.dataSource.listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.deleteRows(indexPath: indexPath)
        }
        deleteButton.backgroundColor = .red
        return [deleteButton]
    }
}

// MARK: UISearchBarDelegate

extension NoteListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        tappedSearchBarDelegate.tappedSearchBar()
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        viewModel?.searchResultPlaces = viewModel?.places?
            .filter { $0.content.contains(text) }
            .compactMap { $0 }
        guard let places = viewModel?.searchResultPlaces else { return }
        dataSource.listItems = places
        ui.animateReload()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.endEditing(true)
        guard let text = searchBar.text else { return false }
        if text.isEmpty {
            dataSource.listItems = viewModel?.places ?? []
            ui.animateReload()
        }
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        dataSource.listItems = viewModel?.places ?? []
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
}

// MARK: NoteListDelegate

extension NoteListViewController: NoteListDelegate {

    @objc func switchNotification(_ isOn: Bool, docId: String) {}
}
