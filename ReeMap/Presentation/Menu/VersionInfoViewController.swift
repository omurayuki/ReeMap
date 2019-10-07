import Foundation
import UIKit

final class VersionInfoViewController: UIViewController {
    
    typealias DataSource = TableViewDataSource<MenuDetailCell, VersionConstitution>
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .groupTableViewBackground
        table.tableFooterView = UIView(frame: .zero)
        table.register(MenuDetailCell.self, forCellReuseIdentifier: String(describing: MenuDetailCell.self))
        return table
    }()
    
    private(set) lazy var dataSource: DataSource = {
        DataSource(cellReuseIdentifier: String(describing: MenuDetailCell.self),
                   listItems: [],
                   cellConfigurationHandler: { cell, item, _ in
            cell.didAccept = item
        })
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        setup()
        setupTable()
    }
}

extension VersionInfoViewController {
    
    private func setup() {
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        tableView.anchor()
            .edgesToSuperview()
            .activate()
    }
    
    private func setupTable() {
        dataSource.listItems = Version.allCases.compactMap { $0.description }
        tableView.reloadData()
    }
}
