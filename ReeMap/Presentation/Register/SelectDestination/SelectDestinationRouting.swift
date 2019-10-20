import CoreLocation
import UIKit

protocol SelectDestinationRoutingProtocol: Routing {
    
    func showCreateMemoPage(address: String)
    func showSearchStreetAddressPage(location: CLLocation)
    func dismiss()
}

final class SelectDestinationRouting: SelectDestinationRoutingProtocol {
    
    weak var viewController: UIViewController?
    
    func showCreateMemoPage(address: String) {
        let vc = AppDelegate.container.resolve(CreateMemoViewController.self)
        vc.didRecieve = address
        viewController?.navigationController?.pushViewController(vc, animated: true)
        vc.viewModel?.didRecieveStreetAddress = address
    }
    
    func showSearchStreetAddressPage(location: CLLocation) {
        let vc = AppDelegate.container.resolve(SearchStreetAddressViewController.self)
        vc.didRecieveCurrentLocation(location)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
