import Foundation

enum Menu: Int, CaseIterable {
    
    case version
    case privacy
    case termsOfService
    case contactUs
    
    var description: String {
        switch self {
        case .version:        return "バージョン情報"
        case .privacy:        return "プライバシーポリシー"
        case .termsOfService: return "利用規約"
        case .contactUs:      return "お問い合わせ"
        }
    }
}

enum Version: Int, CaseIterable {
    
    case version
    
    var description: VersionConstitution {
        switch self {
        case .version:
            return (title: "バージョン", content: "1.0.0(1)")
        }
    }
}
