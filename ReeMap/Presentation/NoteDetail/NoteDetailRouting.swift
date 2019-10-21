import UIKit

protocol NoteDetailRoutingProtocol: Routing {
    
    func showEditPage(streetAddress: String, content: String, documentId: String)
}

final class NoteDetailRouting: NoteDetailRoutingProtocol {
    
    weak var viewController: UIViewController?
    
    func showEditPage(streetAddress: String, content: String, documentId: String) {
        guard let vc = viewController else { return }
        let editVC = AppDelegate.container.resolve(EditNoteViewController.self)
        editVC.modalPresentationStyle = .fullScreen
        vc.present(editVC, animated: true)
        editVC.viewModel?.didRecieveStreetAddress = streetAddress
        editVC.viewModel?.didRecieveNote = content
        editVC.viewModel?.didRecieveNoteId = documentId
    }
}
