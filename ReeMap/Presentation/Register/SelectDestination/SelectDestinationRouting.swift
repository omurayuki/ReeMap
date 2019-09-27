import UIKit

protocol SelectDestinationRoutingProtocol: Routing {
    
    func showCreateMemoPage(address: String)
    func dismiss()
}

final class SelectDestinationRouting: SelectDestinationRoutingProtocol {
    
    weak var viewController: UIViewController?
    
    func showCreateMemoPage(address: String) {
        let vc = AppDelegate.container.resolve(CreateMemoViewController.self)
        vc.didRecieveStreetAddress = address
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
