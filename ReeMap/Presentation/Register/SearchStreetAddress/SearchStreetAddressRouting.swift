import CoreLocation
import UIKit

protocol SearchStreetAddressRoutingProtocol: Routing {
    
    func popViewController(streetAddress: String)
}

final class SearchStreetAddressRouting: SearchStreetAddressRoutingProtocol {
    
    weak var viewController: UIViewController?
    
    func popViewController(streetAddress: String) {
        guard let vc = viewController else { return }
        guard let viewControllers = vc.navigationController?.viewControllers else { return }
        weak var prevVC = viewControllers[viewControllers.count - 2] as? SelectDestinationViewController
        prevVC?.recieveStreetAddress(streetAddress)
        vc.navigationController?.popViewController(animated: true)
    }
}
