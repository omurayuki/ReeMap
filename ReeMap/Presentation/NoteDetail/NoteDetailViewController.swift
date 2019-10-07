import FloatingPanel
import Foundation
import RxCocoa
import RxSwift
import UIKit

final class NoteDetailViewController: UIViewController {
    
    typealias DataSource = TableViewDataSource<NoteDetailCell, NoteDetailConstitution>
    
    private(set) lazy var dataSource: DataSource = {
        DataSource(cellReuseIdentifier: String(describing: NoteDetailCell.self),
                   listItems: [],
                   cellConfigurationHandler: { cell, item, _ in
            cell.didRecieveDetail = item
        })
    }()
    
    private(set) var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.layer.cornerRadius = 13.0
        view.clipsToBounds = true
        return view
    }()
    
    var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.register(NoteDetailCell.self, forCellReuseIdentifier: String(describing: NoteDetailCell.self))
        return table
    }()
    
    var recieveData: NoteDetailConstitution! {
        didSet {
            dataSource.listItems = [recieveData]
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        setup()
    }
}

extension NoteDetailViewController {
    
    private func setup() {
        view.addSubview(visualEffectView)
        visualEffectView.contentView.addSubview(tableView)
        
        visualEffectView.anchor()
            .top(to: view.topAnchor)
            .left(to: view.leftAnchor)
            .right(to: view.rightAnchor)
            .bottom(to: view.bottomAnchor)
            .activate()
        
        tableView.anchor()
            .edgesToSuperview()
            .activate()
    }
    
    func changeTableAlpha(_ alpha: CGFloat) {
        tableView.alpha = alpha
    }
}
