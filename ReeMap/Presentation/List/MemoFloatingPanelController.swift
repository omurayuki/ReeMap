import FloatingPanel
import Foundation
import UIKit

class ContentViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .green
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.addSubview(tableView)
        
        tableView.anchor()
            .top(to: view.topAnchor)
            .left(to: view.leftAnchor)
            .right(to: view.rightAnchor)
            .bottom(to: view.bottomAnchor)
            .activate()
    }
}
