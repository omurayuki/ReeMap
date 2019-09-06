import UIKit

extension UIFont {
    
    class func font(_ size: FontSizes) -> UIFont {
        return UIFont.systemFont(ofSize: size.rawValue)
    }
    
    class func fontBold(_ size: FontSizes) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size.rawValue)
    }
    
    enum FontSizes: CGFloat {
        case fontSize30 = 30.0
        case fontSize22 = 22.0
        case fontSize20 = 20.0
        case fontSize17 = 17.0
        case fontSize16 = 16.0
        case fontSize14 = 14.0
        case fontSize13 = 13.0
        case fontSize12 = 12.0
        case fontSize10 = 10.0
    }
}

extension UIFont {
    
    var bold: UIFont {
        return with(traits: .traitBold)
    }
    
    var regular: UIFont {
        var fontAtrAry = fontDescriptor.symbolicTraits
        fontAtrAry.remove([.traitBold])
        let fontAtrDetails = fontDescriptor.withSymbolicTraits(fontAtrAry)
        // swiftlint:disable:next force_unwrapping
        return UIFont(descriptor: fontAtrDetails!, size: pointSize)
        // swiftlint:disable:previous force_unwrapping
    }
    
    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
