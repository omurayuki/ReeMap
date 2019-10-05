import UIKit

protocol NoteListRoutingProtocol: Routing {
    
    func showCreateMemoPage(note: String, address: String, noteId: String)
}

final class NoteListRouting: NoteListRoutingProtocol {
    
    weak var viewController: UIViewController?
    
    func showCreateMemoPage(note: String, address: String, noteId: String) {
        let vc = EditNoteViewController()
        vc.didRecieveStreetAddress = address
        vc.didRecieveNote = note
        vc.didRecieveNoteId = noteId
        viewController?.present(vc, animated: true)
    }
}
