import Foundation
import UIKit

class TableViewDataSource<CellType, EntityType>: NSObject, UITableViewDataSource {
    
    typealias C = CellType
    
    typealias E = EntityType
    
    private let cellReuseIdentifier: String
    
    private let isSkelton: Bool
    
    private let cellConfigurationHandler: (C, E, IndexPath) -> Void
    
    var listItems: [E]
    
    init(cellReuseIdentifier: String, listItems: [E], isSkelton: Bool, cellConfigurationHandler: @escaping (C, E, IndexPath) -> Void) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.isSkelton = isSkelton
        self.cellConfigurationHandler = cellConfigurationHandler
        self.listItems = listItems
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch isSkelton {
        case true:
            switch listItems.count {
            case 0:  return 0
            default: return listItems.count
            }
        case false:
            return listItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch isSkelton {
        case true:
            switch listItems.count {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
                tableView.isUserInteractionEnabled = true
                cell.isUserInteractionEnabled = true
                return cell
            default:
                let cell = generateCell(tableView, items: listItems, indexPath: indexPath)
                tableView.isUserInteractionEnabled = true
                cell.isUserInteractionEnabled = true
                return cell
            }
        case false:
            return generateCell(tableView, items: listItems, indexPath: indexPath)
        }
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
