import Foundation

enum Menu: Int, CaseIterable {
    
    case memo
    case privacy
    case termsOfService
    case help
    case announce
    case contactUs
    
    var description: String {
        switch self {
        case .memo:           return "メモ作成"
        case .privacy:        return "プライバシー"
        case .termsOfService: return "利用規約"
        case .help:           return "ヘルプ"
        case .announce:       return "お知らせ"
        case .contactUs:      return "お問い合わせ"
        }
    }
}
