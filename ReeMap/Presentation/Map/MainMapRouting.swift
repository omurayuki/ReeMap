import UIKit

protocol MainMapRoutingProtocol: Routing {
    
    func showSettingsAlert(completion: @escaping () -> Void)
    func showSettingsPage()
    func showSelectDestinationPage(annotations: [Annotation]?)
    func showWebViewPage(url: String)
    func showVersionPage()
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
    
    func showSettingsPage() {
        guard let vc = viewController else { return }
        vc.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    func showSelectDestinationPage(annotations: [Annotation]?) {
        let vc = AppDelegate.container.resolve(SelectDestinationViewController.self)
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        viewController?.present(navVC, animated: true)
        vc.viewModel?.didRecieveAnnotations = annotations
    }
    
    func showWebViewPage(url: String) {
        viewController?.navigationController?.pushViewController(WebViewController(url: url), animated: true)
    }
    
    func showVersionPage() {
        viewController?.navigationController?.pushViewController(VersionInfoViewController(), animated: true)
    }
}
