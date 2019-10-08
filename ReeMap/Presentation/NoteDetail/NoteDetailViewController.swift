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
                   cellConfigurationHandler: { [unowned self] cell, item, _ in
            self.bindCell(cell)
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
        table.allowsSelection = false
        table.register(NoteDetailCell.self, forCellReuseIdentifier: String(describing: NoteDetailCell.self))
        return table
    }()
    
    var recieveData: NoteDetailConstitution! {
        didSet {
            dataSource.listItems = [recieveData]
            tableView.reloadData()
        }
    }
    
    let disposeBag = DisposeBag()
    
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
    
    private func bindCell(_ cell: UITableViewCell) {
        guard let cell = cell as? NoteDetailCell else { return }
        
        cell.editBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                let vc = AppDelegate.container.resolve(EditNoteViewController.self)
                vc.didRecieveStreetAddress = self.dataSource.listItems[0].streetAddress
                vc.didRecieveNote = self.dataSource.listItems[0].content
                vc.didRecieveNoteId = self.dataSource.listItems[0].uid
                self.present(vc, animated: true)
            }).disposed(by: disposeBag)
    }
    
    func changeTableAlpha(_ alpha: CGFloat) {
        tableView.alpha = alpha
    }
}
