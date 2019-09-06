import UIKit

protocol MapRoutingProtocol: Routing {
    
}

final class MapRouting: MapRoutingProtocol {
    
    weak var viewController: UIViewController?
}
