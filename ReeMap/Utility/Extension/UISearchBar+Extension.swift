import UIKit

extension UISearchBar {
    func setSearchText(fontSize: CGFloat) {
        #if swift(>=5.1)
        let font = searchTextField.font
        searchTextField.font = font?.withSize(fontSize)
        #else
        guard let textField = value(forKey: "_searchField") as? UITextField else { return }
        textField.font = textField.font?.withSize(fontSize)
        #endif
    }
}

