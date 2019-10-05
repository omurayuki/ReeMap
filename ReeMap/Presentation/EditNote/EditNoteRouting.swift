import UIKit

protocol EditNoteRoutingProtocol: Routing {
    
    func dismiss()
}

final class EditNoteRouting: EditNoteRoutingProtocol {
    
    weak var viewController: UIViewController?
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
