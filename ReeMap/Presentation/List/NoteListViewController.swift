import CoreLocation
import FloatingPanel
import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol TappedSearchBarDelegate: NSObject {
    
    func tappedSearchBar()
}

protocol TappedCellDelegate: NSObject {
    
    func didselectCell(place: Place)
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
    
    weak var tappedSearchBarDelegate: TappedSearchBarDelegate!
    weak var tappedCellDelegate: TappedCellDelegate!
    private var places: [Place]?
    private var placesForDeletion: [Place]?
    private var searchResultPlaces: [Place]?
    private var placeForEditing: (note: String, address: String, noteId: String)?
    
    var didAcceptPlaces: [Place]? {
        didSet {
            guard let places = didAcceptPlaces else { return }
            dataSource.listItems = places
            self.places = places
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
}

extension NoteListViewController {
    
    private func deleteRows(indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [unowned self] in
            guard let places = self.placesForDeletion else { return }
            self.viewModel?.deleteNote(place: places[indexPath.row])
                .subscribe(onError: { [unowned self] _ in
                        self.showError(message: R.string.localizable.could_not_delete())
                }).disposed(by: self.disposeBag)
        })
    }
}

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tappedCellDelegate.didselectCell(place: dataSource.listItems[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .normal, title: R.string.localizable.delete()) { [unowned self] _, _ in
            //// didEndEditingRowAtで使用するため、一旦コピー
            self.placesForDeletion = self.dataSource.listItems
            self.dataSource.listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.deleteRows(indexPath: indexPath)
        }
        deleteButton.backgroundColor = .red
        return [deleteButton]
    }
}

extension NoteListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        tappedSearchBarDelegate.tappedSearchBar()
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        searchResultPlaces = places?
            .filter { $0.content.contains(text) }
            .compactMap { $0 }
        guard let places = searchResultPlaces else { return }
        dataSource.listItems = places
        ui.animateReload()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.endEditing(true)
        guard let text = searchBar.text else { return false }
        if text.isEmpty {
            dataSource.listItems = places ?? []
            ui.animateReload()
        }
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        dataSource.listItems = places ?? []
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
}
