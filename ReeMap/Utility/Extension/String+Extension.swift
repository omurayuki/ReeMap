import Foundation

extension String {
    /// 文字列→日付に変換する
    ///
    /// - Parameter format: フォーマット
    /// - Returns: 変換後の日付
    public func toDate(format: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: format,
                                                        options: 0,
                                                        locale: Locale(identifier: "ja_JP"))
        guard let date = formatter.date(from: self) else {
            return Date()
        }
        
        return date
    }
    
    func getStreetAddress() -> String {
        var value = self.components(separatedBy: ", ")
        if value[0].contains("〒") {
            value.removeFirst()
        }
        return value.joined()
    }
}
