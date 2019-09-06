import Foundation
import UIKit

extension UIButton {
    
    class Builder {
        private let buttonType: UIButton.ButtonType
        
        private var title: String?
        private var image: UIImage?
        private var component: TextComponent?
        
        private var titleEdgeInsets: UIEdgeInsets = .zero
        private var imageEdgeInsets: UIEdgeInsets = .zero
        
        private var backgroundColor: UIColor?
        private var tintColor: UIColor?
        
        private var cornerRadius: CGFloat = 0
        private var borderWidth: CGFloat = 0
        private var width: CGFloat = 0
        private var height: CGFloat = 0
        private var borderColor = UIColor.black.cgColor
        private var contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        
        init(type: UIButton.ButtonType = .system) {
            buttonType = type
        }
        
        func title(_ title: String) -> Builder {
            self.title = title
            return self
        }
        
        func image(_ image: UIImage) -> Builder {
            self.image = image
            return self
        }
        
        func component(_ component: TextComponent) -> Builder {
            self.component = component
            return self
        }
        
        func titleEdgeInsets(_ titleEdgeInsets: UIEdgeInsets) -> Builder {
            self.titleEdgeInsets = titleEdgeInsets
            return self
        }
        
        func imageEdgeInsets(_ imageEdgeInsets: UIEdgeInsets) -> Builder {
            self.imageEdgeInsets = imageEdgeInsets
            return self
        }
        
        func backgroundColor(_ backgroundColor: UIColor) -> Builder {
            self.backgroundColor = backgroundColor
            return self
        }
        
        func cornerRadius(_ cornerRadius: CGFloat) -> Builder {
            self.cornerRadius = cornerRadius
            return self
        }
        
        func border(width: CGFloat, color: CGColor) -> Builder {
            self.borderWidth = width
            self.borderColor = color
            return self
        }
        
        func size(width: CGFloat, height: CGFloat) -> Builder {
            self.width = width
            self.height = height
            return self
        }
        
        func tintColor(_ color: UIColor) -> Builder {
            self.tintColor = color
            return self
        }
        
        func contentHorizontalAlignment(_ contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) -> Builder {
            self.contentHorizontalAlignment = contentHorizontalAlignment
            return self
        }
        
        func build() -> UIButton {
            let button = UIButton(type: buttonType)
            button.apply(component ?? .title, title: title, image: image)
            button.titleEdgeInsets = titleEdgeInsets
            button.imageEdgeInsets = imageEdgeInsets
            button.backgroundColor = backgroundColor
            button.layer.cornerRadius = cornerRadius
            button.layer.borderWidth = borderWidth
            button.layer.borderColor = borderColor
            button.frame = CGRect(x: 0, y: 0, width: width, height: height)
            button.contentHorizontalAlignment = contentHorizontalAlignment
            button.tintColor = tintColor
            return button
        }
    }
    
    func apply(_ textComponent: TextComponent, title: String? = nil, image: UIImage? = nil) {
        if let t = title {
            setTitle(t, for: .normal)
        }
        if let i = image {
            setImage(i, for: .normal)
            tintColor = textComponent.textColor
            tintAdjustmentMode = .normal
        }
        setTitleColor(textComponent.textColor, for: .normal)
        titleLabel?.font = textComponent.font
    }
}
