import Foundation
import UIKit

extension UILabel {
    
    func apply(_ textComponent: TextComponent, title: String? = nil) {
        
        if let t = title {
            text = t
        }
        
        textColor = textComponent.textColor
        backgroundColor = .clear
        font = textComponent.font
    }
}
