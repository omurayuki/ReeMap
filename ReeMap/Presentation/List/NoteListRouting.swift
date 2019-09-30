import UIKit

protocol NoteListRoutingProtocol: Routing {
    
}

final class NoteListRouting: NoteListRoutingProtocol {
    
    weak var viewController: UIViewController?
}
