import Foundation
import UIKit

enum TextComponent {
    case h1
    case h1_LightGray
    case h1_CharcoalGrey
    case h1_Bold
    case h1_Bold_White
    case h1_Bold_LightGray
    case h1_Bold_CharcoalGrey
    case h1_Bold_OliveGreen
    case h2
    case h2_LightGray
    case h2_White
    case h2_LightishGreen
    case h2_OliveGreen
    case h2_Bold
    case h2_Bold_LightGray
    case h3
    case h3_White
    case h3_coolGrey
    case h3_CharcoalGrey
    case h3_OliveGreen
    case h3_Bold
    case h4
    case h4_White
    case h4_CharcoalGrey
    case h4_CharcoalGrey25
    case h4_LightishGreen
    case h4_ReddishOrange
    case h4_PurpleyGrey
    case h4_CoolGrey
    case h4_Bold
    case h5
    case h5_Bold
    case h4_appMain
    case title
    case title_White
    case title_Black40
    case title_CharcoalGrey
    case title_LightishGreen
    case title_Bold
    case title_Bold_LightishGreen
    case body
    case body_White
    case body_LightGray
    case body_CharcoalGrey
    case body_CharcoalGrey80
    case body_CoolGrey
    case body_darkGray
    case body_Bold
    case body_Bold_White
    case cap
    case cap_White
    case cap_LightGray
    case cap_Bold
    case cap_Bold_White
    case appMain
    case body_CoolGrey13
    case body_darkGray13
    case appMain10
    case h5_appSub_bold
    case h6_appSub_bold
    case h5_appSub
    case h3_appSub
    case body_CoolGrey16
    case appSub
    case h4_bold_appMain
    
    var font: UIFont {
        switch self {
        case .h1, .h1_LightGray, .h1_CharcoalGrey:
            return .font(.fontSize30)
        case .h2, .h2_LightGray, .h2_White, .h2_LightishGreen, .h2_OliveGreen:
            return .font(.fontSize22)
        case .h3, .h3_White, .h3_coolGrey, .h3_CharcoalGrey, .h3_OliveGreen:
            return .font(.fontSize20)
        case .h4, .h4_White, .h4_CharcoalGrey25, .h4_CharcoalGrey, .h4_LightishGreen, .h4_ReddishOrange, .h4_PurpleyGrey, .h4_CoolGrey, .h4_appMain:
            return .font(.fontSize17)
        case .title, .title_White, .title_Black40, .title_CharcoalGrey, .title_LightishGreen, .title_Bold_LightishGreen, .body_CoolGrey13, .body_darkGray13:
            return .font(.fontSize13)
        case .h5, .h5_appSub, .body_CoolGrey16:
            return .font(.fontSize16)
        case .body, .body_LightGray, .body_CharcoalGrey80, .body_CoolGrey, .body_CharcoalGrey, .body_White, .body_darkGray:
            return .font(.fontSize12)
        case .cap, .cap_White, .cap_LightGray:
            return .font(.fontSize10)
        case .h1_Bold, .h1_Bold_White, .h1_Bold_LightGray, .h1_Bold_CharcoalGrey, .h1_Bold_OliveGreen:
            return .fontBold(.fontSize30)
        case .h2_Bold, .h2_Bold_LightGray:
            return .fontBold(.fontSize22)
        case .h3_Bold, .h3_appSub:
            return .fontBold(.fontSize20)
        case .h4_Bold, .h4_bold_appMain:
            return .fontBold(.fontSize17)
        case .h5_Bold, .h5_appSub_bold:
            return .fontBold(.fontSize16)
        case .h6_appSub_bold:
            return .fontBold(.fontSize14)
        case .title_Bold, .appMain, .appSub:
            return .fontBold(.fontSize13)
        case .body_Bold, .body_Bold_White:
            return .fontBold(.fontSize12)
        case .cap_Bold, .cap_Bold_White, .appMain10:
            return .fontBold(.fontSize10)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .h1, .h2, .h3, .h4, .title, .body, .cap, .h1_Bold, .h2_Bold, .h3_Bold, .h4_Bold, .h5_Bold, .title_Bold, .body_Bold, .cap_Bold, .h5:
            return .black
        case .h1_Bold_White, .h2_White, .h3_White, .h4_White, .title_White, .body_White, .body_Bold_White, .cap_White, .cap_Bold_White:
            return .white
        case .body_darkGray13, .body_darkGray:
            return .darkGray
        case .title_Black40:
            return .appBlack40
        case .h1_LightGray, .h1_Bold_LightGray, .h2_LightGray, .h2_Bold_LightGray, .body_LightGray, .cap_LightGray:
            return .appLightGrey
        case .h1_CharcoalGrey, .h1_Bold_CharcoalGrey, .h3_CharcoalGrey, .h4_CharcoalGrey, .title_CharcoalGrey, .body_CharcoalGrey:
            return .appCharcoalGrey
        case .h4_CharcoalGrey25:
            return .appCharcoalGrey25
        case .body_CharcoalGrey80:
            return .appCharcoalGrey80
        case .body_CoolGrey, .h3_coolGrey, .h4_CoolGrey, .body_CoolGrey13, .body_CoolGrey16:
            return .appCoolGrey
        case .h2_LightishGreen, .h4_LightishGreen, .title_LightishGreen, .title_Bold_LightishGreen:
            return .appLightishGreen
        case .h4_ReddishOrange:
            return .appReddishOrange
        case .h4_PurpleyGrey:
            return .appPurpleyGrey
        case .h1_Bold_OliveGreen, .h2_OliveGreen, .h3_OliveGreen:
            return .appOliveGreen
        case .h4_appMain, .appMain, .appMain10, .h5_appSub_bold, .h6_appSub_bold, .h5_appSub, .h3_appSub, .h4_bold_appMain:
            return .appSubColor
        case .appSub:
            return .appMainColor
        }
    }
}
