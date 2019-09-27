import UIKit

protocol CreateMemoRoutingProtocol: Routing {
    
    func dismiss()
}

final class CreateMemoRouting: CreateMemoRoutingProtocol {
    
    weak var viewController: UIViewController?
    
    func dismiss() {
        viewController?.navigationController?.dismiss(animated: true)
    }
}
