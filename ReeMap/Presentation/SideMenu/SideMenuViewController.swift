import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol SideMenuViewControllerDelegate: NSObject {
    
    func sidemenuViewController(_ sidemenuViewController: SideMenuViewController, didSelectItemAt indexPath: IndexPath)
}

class SideMenuViewController: UIViewController {
    
    typealias DataSource = TableViewDataSource<SideMenuCell, String>
    
    private(set) lazy var dataSource: DataSource = {
        DataSource(cellReuseIdentifier: String(describing: SideMenuCell.self),
                   listItems: [],
                   cellConfigurationHandler: { cell, item, _ in
            cell.title.text = item
        })
    }()
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    private lazy var ui: SideMenuUIProtocol = {
        let ui = SideMenuUI()
        ui.viewController = self
        return ui
    }()
    
    let disposeBag = DisposeBag()
    
    private var beganLocation: CGPoint = .zero
    private var beganState: Bool = false
    private var contentRatio: CGFloat {
        get {
            return ui.contentView.frame.maxX / view.bounds.width * 0.7
        }
        set {
            ui.changeContentRatio(ratio: newValue)
        }
    }
    
    var isShown: Bool { return self.parent != nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ui.setup()
        setupViewModel()
        ui.tableView.dataSource = dataSource
        ui.tableView.delegate = self
        ui.tapGesture.delegate = self
        ui.tableView.reloadData()
        dataSource.listItems = ["メモ作成", "設定", "お問い合わせ", "ホホホイ"]
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
