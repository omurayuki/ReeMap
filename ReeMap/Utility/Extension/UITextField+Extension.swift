import Foundation
import UIKit

extension UITextField {
    func apply(_ textComponent: TextComponent, hint: String? = nil) {
        
        if let h = hint {
            placeholder = h
        }
        
        textColor = textComponent.textColor
        font = textComponent.font
        backgroundColor = .clear
        borderStyle = .none
    }
}
