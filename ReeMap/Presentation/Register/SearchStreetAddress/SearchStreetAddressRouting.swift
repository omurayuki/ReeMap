import CoreLocation
import UIKit

protocol SearchStreetAddressRoutingProtocol: Routing {
    
    func popViewController(streetAddress: String)
}

final class SearchStreetAddressRouting: SearchStreetAddressRoutingProtocol {
    
    weak var viewController: UIViewController?
    
    func popViewController(streetAddress: String) {
        guard let vc = viewController else { return }
        guard let prevVC = vc.navigationController?.viewControllers[(vc.navigationController?.viewControllers.count)! - 2] as? SelectDestinationViewController else { return }
        prevVC.recieveStreetAddress(streetAddress)
        vc.navigationController?.popViewController(animated: true)
    }
}
