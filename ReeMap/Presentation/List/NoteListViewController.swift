import FloatingPanel
import Foundation
import UIKit

class NoteListViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.contentInset.top = 400
        table.backgroundColor = .white
        table.register(NoteListTableViewCell.self, forCellReuseIdentifier: String(describing: NoteListTableViewCell.self))
        return table
    }()
    
    var header: NoteTableHeaderView = {
        let view = NoteTableHeaderView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let headerView = tableView.tableHeaderView as? NoteTableHeaderView {
            tableView.tableHeaderView?.frame.size.height = headerView.noteContent.frame.height + 150
            tableView.reloadData()
        }
    }
    
    func setup() {
        view.addSubview(tableView)
        tableView.tableHeaderView = header
        
        tableView.anchor()
            .top(to: view.topAnchor)
            .left(to: view.leftAnchor)
            .right(to: view.rightAnchor)
            .bottom(to: view.bottomAnchor)
            .activate()
    }
    
    func changeTableAlpha(_ alpha: CGFloat) {
        tableView.alpha = alpha
    }
}

extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NoteListTableViewCell.self),
                                                     for: indexPath) as? NoteListTableViewCell
        else { return UITableViewCell() }
        return cell
    }
}
