import FloatingPanel
import Foundation
import RxCocoa
import RxSwift
import UIKit

extension NoteDetailViewController: VCInjectable {
    
    typealias UI = NoteDetailUIProtocol
    typealias Routing = NoteDetailRoutingProtocol
    typealias ViewModel = Nillable
    typealias DataSource = TableViewDataSource<NoteDetailCell, NoteDetailConstitution>
    
    func setupConfig() {
        ui.tableView.dataSource = dataSource
    }
}

final class NoteDetailViewController: UIViewController {
    
    var ui: NoteDetailUIProtocol! { didSet { ui.viewController = self } }
    var routing: NoteDetailRoutingProtocol? { didSet { routing?.viewController = self } }
    var viewModel: Nillable?
    var disposeBag: DisposeBag!
    
    weak var delegate: NoteDetailDelegate!
    
    var recieveData: NoteDetailConstitution! {
        didSet {
            dataSource.listItems = [recieveData]
            ui.tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource
    
    private(set) lazy var dataSource: DataSource = {
        DataSource(cellReuseIdentifier: String(describing: NoteDetailCell.self),
                   listItems: [],
                   cellConfigurationHandler: { [unowned self] cell, item, _ in
            self.bindCell(cell)
            cell.didRecieveDetail = item
        })
    }()
    
    override func loadView() {
        super.loadView()
        ui.setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConfig()
    }
}

extension NoteDetailViewController {
    
    private func bindCell(_ cell: UITableViewCell) {
        guard let cell = cell as? NoteDetailCell else { return }
        
        cell.editBtn.rx.tap.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.routing?.showEditPage(streetAddress: self.recieveData.streetAddress,
                                           content: self.recieveData.content,
                                           documentId: self.recieveData.documentId)
                self.delegate.tappedEditBtn()
            }).disposed(by: disposeBag)
    }
    
    func changeTableAlpha(_ alpha: CGFloat) {
        ui.tableView.alpha = alpha
    }
}
