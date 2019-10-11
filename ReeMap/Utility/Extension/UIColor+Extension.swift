import Foundation
import UIKit

extension UIColor {
    
    // swiftlint:enable:next object_literal
    // swiftlint:enable:next discouraged_object_literal
    class var appFacebookColor: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152 / 255.0, alpha: 1.0)
    }
    
    class var appTwitterColor: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 172.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
    }
    
    class var appLightishGreen: UIColor {
        return UIColor(red: 96.0 / 255.0, green: 216.0 / 255.0, blue: 124.0 / 255.0, alpha: 1.0)
    }
    
    class var appCoolGrey: UIColor {
        return UIColor(red: 172.0 / 255.0, green: 172.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
    }
    
    class var appPaleGrey: UIColor {
        return UIColor(red: 247.0 / 255.0, green: 248.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
    
    class var appCharcoalGrey: UIColor {
        return UIColor(red: 46.0 / 255.0, green: 47.0 / 255.0, blue: 52.0 / 255.0, alpha: 1.0)
    }
    
    class var appCharcoalGrey20: UIColor {
        return UIColor(red: 46.0 / 255.0, green: 47.0 / 255.0, blue: 52.0 / 255.0, alpha: 0.2)
    }
    
    class var appCharcoalGrey25: UIColor {
        return UIColor(red: 46.0 / 255.0, green: 47.0 / 255.0, blue: 52.0 / 255.0, alpha: 0.25)
    }
    
    class var appCharcoalGrey35: UIColor {
        return UIColor(red: 46.0 / 255.0, green: 47.0 / 255.0, blue: 52.0 / 255.0, alpha: 0.2)
    }
    
    class var appCharcoalGrey80: UIColor {
        return UIColor(red: 46.0 / 255.0, green: 47.0 / 255.0, blue: 52.0 / 255.0, alpha: 0.8)
    }
    
    class var appLightGrey: UIColor {
        return UIColor(red: 240.0 / 255.0, green: 240.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
    }
    
    class var appPurpleyGrey: UIColor {
        return UIColor(red: 143.0 / 255.0, green: 142.0 / 255.0, blue: 148.0 / 255.0, alpha: 1.0)
    }
    
    class var appBlack40: UIColor {
        return UIColor(white: 0.0, alpha: 0.4)
    }
    
    class var appReddishOrange: UIColor {
        return UIColor(red: 245.0 / 255.0, green: 87.0 / 255.0, blue: 35.0 / 255.0, alpha: 1.0)
    }
    
    class var appSilver: UIColor {
        return UIColor(red: 200.0 / 255.0, green: 199.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
    }
    
    class var appDarkWhite: UIColor {
        return UIColor(white: 231.0 / 255.0, alpha: 1.0)
    }
    
    class var appOliveGreen: UIColor {
        return #colorLiteral(red: 0.6196078431, green: 0.7019607843, blue: 0.05882352941, alpha: 1)
    }
    
    class var appMainColor: UIColor {
        return UIColor(red: 243.0 / 255.0, green: 243.0 / 255.0, blue: 243.0 / 255.0, alpha: 1)
    }
    
    class var appSubColor: UIColor {
        return UIColor(red: 49.0 / 255.0, green: 56.0 / 255.0, blue: 64.0 / 255.0, alpha: 1)
    }
    
    class var appMainSupportColor: UIColor {
        return UIColor(red: 246.0 / 255.0, green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1)
    }
    
    class var appSelectColor: UIColor {
        return UIColor(red: 95.0 / 255.0, green: 103.0 / 255.0, blue: 112.0 / 255.0, alpha: 1)
    }
    
    class var tabbarColor: UIColor {
        return UIColor(red: 247.0 / 255.0, green: 247.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
    }
    
    class var systemGrayColor: UIColor {
        return UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1)
    }

    class var flatRed: UIColor {
        return UIColor(hex: "e74c3c")
    }
    
    class var flatBlue: UIColor {
        return UIColor(hex: "0096E6")
    }
    
    class var annotationDefaultColor: UIColor {
        return UIColor(hex: "FE5C47")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha: 1.0)
    }
}
