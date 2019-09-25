import UIKit

protocol MainMapRoutingProtocol: Routing {
    
    func showSettingsAlert(completion: @escaping () -> Void)
}

final class MainMapRouting: MainMapRoutingProtocol {
    
    weak var viewController: UIViewController?
    
    func showSettingsAlert(completion: @escaping () -> Void) {
        viewController?.showAlertSheet(title: R.string.localizable.change_settings_title(),
                                       message: R.string.localizable.attention_message(),
                                       actionTitle: R.string.localizable.settings_title()) {
            completion()
        }
    }
}
