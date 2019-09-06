// swiftlint:disable all
import Accounts
import Foundation
import Social
import MBProgressHUD
import MessageUI
import UIKit

extension UIViewController {
    
    func dismissOrPopViewController() {
        guard self.navigationController?.viewControllers.count != 1 else {
            self.navigationController?.dismiss(animated: true)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func dismissAndEndEditing() {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    func setBackButton(title: String) {
        let backButton = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setUserInteraction(enabled: Bool) {
        view.isUserInteractionEnabled = enabled
        if let navi = navigationController {
            navi.view.isUserInteractionEnabled = enabled
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController.createSimpleOkMessage(title: "エラー", message: message)
        present(alert, animated: true)
    }
    
    func showSuccess(message: String) {
        let alert = UIAlertController.createSimpleOkMessage(title: "成功", message: message)
        present(alert, animated: true)
    }
    
    func validatePasswordMatch(pass: String, rePass: String, completion: @escaping (_ pass: String?) -> Void) {
        pass == rePass ? completion(pass) : completion(nil)
    }
    
    func setIndicator(show: Bool) {
        if show {
            MBProgressHUD.showAdded(to: view, animated: true)
        } else {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    func clearNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func undoNavBar() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    func coloringAppMainNavBar() {
        navigationController?.navigationBar.barTintColor = .appMainColor
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func showActionSheet(title: String, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController.createActionSheet(title: title,
                                                        message: message,
                                                        okCompletion: {
                                                            completion()
        })
        present(alert, animated: true)
    }
}
