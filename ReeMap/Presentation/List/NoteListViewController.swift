import CoreLocation
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
    private var placesForDeletion = [Place]()
    
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

extension NoteListViewController {
    
    private func getPlacemark(location: CLLocation, place: Place) {
        viewModel?.getPlacemarks(location: location)
            .subscribe(onSuccess: { [unowned self] placemark in
                self.ui.changeTableAlpha(0.9)
                self.ui.showHeader(content: place.content, address: self.getStreetAddress(placemark: placemark))
            }, onError: { [unowned self] _ in
                self.showError(message: R.string.localizable.attention_could_not_load_location())
            }).disposed(by: disposeBag)
    }
}

extension NoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = dataSource.listItems[indexPath.row]
        let location = CLLocation(latitude: place.latitude, longitude: place.longitude)
        getPlacemark(location: location, place: place)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .normal, title: R.string.localizable.delete()) { [unowned self] _, _ in
            //// didEndEditingRowAtで使用するため、一旦コピー
            self.placesForDeletion = self.dataSource.listItems
            self.dataSource.listItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteButton.backgroundColor = .red
        return [deleteButton]
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let index = indexPath?.row else { return }
        viewModel?.deleteNote(place: placesForDeletion[index])
            .subscribe(onError: { [unowned self] _ in
                self.showError(message: R.string.localizable.could_not_delete())
            }).disposed(by: disposeBag)
    }
}

extension NoteListViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        delegate.tappedSearchBar()
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.ui.showHeader(content: "search bar でっせ", address: "")
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.endEditing(true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        ui.hideHeader()
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
}
