import Foundation
import UIKit

class TableViewDataSource<CellType, EntityType>: NSObject, UITableViewDataSource {
    
    typealias C = CellType
    
    typealias E = EntityType
    
    private let cellReuseIdentifier: String
    
    private let cellConfigurationHandler: (C, E, IndexPath) -> Void
    
    var listItems: [E]
    
    init(cellReuseIdentifier: String, listItems: [E], cellConfigurationHandler: @escaping (C, E, IndexPath) -> Void) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.cellConfigurationHandler = cellConfigurationHandler
        self.listItems = listItems
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return generateCell(tableView, items: listItems, indexPath: indexPath)
    }
}

extension TableViewDataSource {
    
    // swiftlint:enable:next force_cast 
    private func generateCell(_ tableView: UITableView, items: [E], indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let listItem = items[indexPath.row]
        cellConfigurationHandler(cell as! C, listItem, indexPath)
        return cell
    }
}
