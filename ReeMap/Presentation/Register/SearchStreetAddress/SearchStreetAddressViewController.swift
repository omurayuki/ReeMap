import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift
import UIKit

extension SearchStreetAddressViewController: VCInjectable {
    
    typealias UI = SearchStreetAddressUIProtocol
    typealias Routing = SearchStreetAddressRoutingProtocol
    typealias ViewModel = SearchStreetAddressViewModel
    typealias DataSource = TableViewDataSource<StreetAddressCell, MKMapItem>
    
    func setupConfig() {
        ui.tableView.dataSource = dataSource
        ui.tableView.delegate = self
    }
}

final class SearchStreetAddressViewController: UIViewController {
    
    var ui: SearchStreetAddressUIProtocol! { didSet { ui.viewController = self } }
    var routing: SearchStreetAddressRoutingProtocol? { didSet { routing?.viewController = self } }
    var viewModel: SearchStreetAddressViewModel?
    var disposeBag: DisposeBag!
    
    // MARK: - UITableViewDataSource
    
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
        bindUI()
        FirebaseAnalyticsUtil.setScreenName(.searchDestination, screenClass: String(describing: type(of: self)))
    }
}

extension SearchStreetAddressViewController {
    
    private func bindUI() {
        let input = ViewModel.Input(updateText: ui.searchController.searchBar.rx.text.orEmpty.asObservable())
        let output = viewModel?.transform(input: input)
        
        output?.searchResultSuccess
            .subscribe(onNext: { [unowned self] mapItems in
                self.ui.generateTableView()
                self.dataSource.listItems = mapItems
                self.ui.tableView.reloadData()
            }).disposed(by: disposeBag)
        
        output?.searchResultError
            .subscribe(onNext: { [unowned self] _ in
                self.showError(message: R.string.localizable.could_not_get())
            }).disposed(by: disposeBag)
        
        output?.isSearchFieldEmpty
            .subscribe(onNext: { [unowned self] isEmpty in
                if isEmpty {
                    self.dataSource.listItems = []
                    self.ui.hideTable()
                }
            }).disposed(by: disposeBag)
    }
}

extension SearchStreetAddressViewController {
    
    func didRecieveCurrentLocation(_ location: CLLocation) {
        self.viewModel?.setLocation(location)
    }
}

// MARK: - UITableViewDelegate

extension SearchStreetAddressViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let streetAddress = dataSource.listItems[indexPath.row].placemark.title else { return }
        routing?.popViewController(streetAddress: streetAddress)
    }
}
