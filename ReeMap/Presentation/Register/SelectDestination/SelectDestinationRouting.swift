import UIKit

protocol SelectDestinationRoutingProtocol: Routing {
    
    func showCreateMemoPage(address: String)
}

final class SelectDestinationRouting: SelectDestinationRoutingProtocol {
    
    weak var viewController: UIViewController?
    
    func showCreateMemoPage(address: String) {
        let vc = CreateMemoViewController()
        vc.didRecieveStreetAddress = address
        vc.navigationController?.pushViewController(vc, animated: true)
    }
}
