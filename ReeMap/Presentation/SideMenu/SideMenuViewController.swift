import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol SideMenuViewControllerDelegate: NSObject {
    
    func sidemenuViewController(_ sidemenuViewController: SideMenuViewController, didSelectItemAt indexPath: IndexPath)
}

extension SideMenuViewController: VCInjectable {
    
    typealias UI = SideMenuUIProtocol
    typealias Routing = Nillable
    typealias ViewModel = Nillable
    typealias DataSource = TableViewDataSource<SideMenuCell, String>
    
    func setupConfig() {
        ui.tableView.dataSource = dataSource
        ui.tableView.delegate = self
        ui.tapGesture.delegate = self
    }
}

class SideMenuViewController: UIViewController {
    
    var ui: SideMenuUIProtocol! { didSet { ui.viewController = self } }
    var routing: Nillable?
    var viewModel: Nillable?
    var disposeBag: DisposeBag!
    
    private(set) lazy var dataSource: DataSource = {
        DataSource(cellReuseIdentifier: String(describing: SideMenuCell.self),
                   listItems: [],
                   cellConfigurationHandler: { cell, item, _ in
            cell.title.text = item
        })
    }()
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    var isShown: Bool { return self.parent != nil }
    private var beganLocation: CGPoint = .zero
    private var beganState: Bool = false
    private var contentRatio: CGFloat {
        get {
            return ui.contentView.frame.maxX / view.bounds.width * 0.6
        }
        set {
            ui.changeContentRatio(ratio: newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        setupViewModel()
        setupConfig()
        dataSource.listItems = Menu.allCases.compactMap { $0.description }
        ui.tableView.reloadData()
    }
    
    private func setupViewModel() {
        ui.tapGesture.rx.event.asDriver()
            .drive(onNext: { [unowned self] _ in
                self.hideContentView(animated: true) { [unowned self] _ in
                    self.willMove(toParent: nil)
                    self.removeFromParent()
                    self.view.removeFromSuperview()
                }
            }).disposed(by: disposeBag)
    }
    
    func showContentView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.contentRatio = 1.0
            }
        } else {
            contentRatio = 1.0
        }
    }
    
    func hideContentView(animated: Bool, completion: ((Bool) -> Swift.Void)?) {
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.contentRatio = 0
            }, completion: { finished in
                completion?(finished)
            })
        } else {
            contentRatio = 0
            completion?(true)
        }
    }
}

extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.sidemenuViewController(self, didSelectItemAt: indexPath)
    }
}

extension SideMenuViewController: UIGestureRecognizerDelegate {
    
    internal func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: ui.tableView)
        if ui.tableView.indexPathForRow(at: location) != nil {
            return false
        }
        return true
    }
}
