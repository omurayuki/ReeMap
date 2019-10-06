import Foundation

enum Menu: Int, CaseIterable {
    
    case version
    case privacy
    case termsOfService
    case help
    case contactUs
    
    var description: String {
        switch self {
        case .version:        return "Version 1.0.0(1)"
        case .privacy:        return "プライバシー"
        case .termsOfService: return "利用規約"
        case .help:           return "ヘルプ"
        case .contactUs:      return "お問い合わせ"
        }
    }
}
