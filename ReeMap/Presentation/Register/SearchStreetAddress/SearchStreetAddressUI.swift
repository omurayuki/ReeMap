import MapKit
import UIKit

protocol SearchStreetAddressUIProtocol: UI {
    
    var searchController: UISearchController { get }
    var tableView: UITableView { get }
    
    func generateTableView()
    func hideTable()
}

final class SearchStreetAddressUI: SearchStreetAddressUIProtocol {
    
    weak var viewController: UIViewController?
    
    private(set) var searchController: UISearchController = {
        let searchVC = UISearchController(searchResultsController: nil)
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Search Destination"
        return searchVC
    }()
    
    private(set) var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.isHidden = true
        table.register(StreetAddressCell.self, forCellReuseIdentifier: String(describing: StreetAddressCell.self))
        return table
    }()
}

extension SearchStreetAddressUI {
    
    func setup() {
        guard let vc = viewController else { return }
        vc.view.backgroundColor = .white
        vc.navigationItem.searchController = searchController
        vc.definesPresentationContext = true
    }
    
    func generateTableView() {
        guard let vc = viewController else { return }
        vc.view.addSubview(tableView)
        
        tableView.anchor()
            .top(to: vc.view.topAnchor)
            .left(to: vc.view.leftAnchor)
            .right(to: vc.view.rightAnchor)
            .bottom(to: vc.view.bottomAnchor)
            .activate()
        tableView.isHidden = false
    }
    
    func hideTable() {
        tableView.reloadData()
        tableView.isHidden = true
    }
}
