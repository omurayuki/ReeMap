import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift
import UIKit

extension MKMapItem: Model {}

extension SearchStreetAddressViewController: VCInjectable {
    
    typealias UI = SearchStreetAddressUIProtocol
    typealias Routing = SearchStreetAddressRoutingProtocol
    typealias ViewModel = SearchStreetAddressViewModel
    typealias DataSource = TableViewDataSource<StreetAddressCell, MKMapItem>
    
    func setupConfig() {
        ui.tableView.dataSource = dataSource
        ui.tableView.delegate = self
        ui.searchController.searchResultsUpdater = self
        ui.searchController.searchBar.delegate = self
    }
}

final class SearchStreetAddressViewController: UIViewController {
    
    var ui: SearchStreetAddressUIProtocol! { didSet { ui.viewController = self } }
    var routing: SearchStreetAddressRoutingProtocol? { didSet { routing?.viewController = self } }
    var viewModel: SearchStreetAddressViewModel?
    var disposeBag: DisposeBag!
    
    private var location: CLLocation!
    
    private(set) lazy var dataSource: DataSource = {
        DataSource(cellReuseIdentifier: String(describing: StreetAddressCell.self),
                   listItems: [],
                   cellConfigurationHandler: { cell, item, _ in
            cell.mapItem = item
        })
    }()
    
    override func loadView() {
        super.loadView()
        ui.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
        
        FirebaseAnalyticsUtil.setScreenName(.searchDestination, screenClass: String(describing: type(of: self)))
    }
}

extension SearchStreetAddressViewController {
    
    func didRecieveCurrentLocation(_ location: CLLocation) {
        self.location = location
    }
}

extension SearchStreetAddressViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let streetAddress = dataSource.listItems[indexPath.row].placemark.title else { return }
        routing?.popViewController(streetAddress: streetAddress)
    }
}

extension SearchStreetAddressViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if !text.isEmpty {
            viewModel?.acquisitionSearchedResult(query: text, location: location)
                .subscribe(onSuccess: { [unowned self] mapItems in
                    self.ui.generateTableView()
                    self.dataSource.listItems = mapItems
                    self.ui.tableView.reloadData()
                    }, onError: { [unowned self] _ in
                        self.showError(message: R.string.localizable.could_not_get())
                }).disposed(by: disposeBag)
        }
    }
}

extension SearchStreetAddressViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        guard let bool = searchBar.text?.isEmpty else { return false }
        if bool {
            dataSource.listItems = []
            ui.hideTable()
        }
        return true
    }
}
