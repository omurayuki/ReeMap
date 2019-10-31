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

extension String {
    
    func convertAttributedString() -> NSMutableAttributedString? {
        let html = self._removePT()
        guard let encoded = html.data(using: String.Encoding.utf8) else { return nil }
        let attributedOptions: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        do {
            let attributedTxt = try NSMutableAttributedString(data: encoded, options: attributedOptions, documentAttributes: nil)
            return attributedTxt
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    fileprivate func _removePT() -> String {
        let pattern = "<style(.|\n)*style>"
        var ranges: [NSRange] = []
        _ = self.pregMatche(pattern: pattern, target: nil, ranges: &ranges)
        var targets: [NSRange] = []
        ranges.forEach {
            var ranges: [NSRange] = []
            _ = self.pregMatche(pattern: "font\\-size: \\d*.*pt", target: $0, ranges: &ranges)
            targets += ranges
        }
        
        let result = targets.reduce(self) { (result, range) -> String in
            result.pregReplace(pattern: "pt", with: "px", range: range)
        }
        return result
    }
    
    fileprivate func addCSSStyle(style: String) -> String? {
        let pattern = "<\\/style>"
        var range: [NSRange] = []
        _ = self.pregMatche(pattern: pattern, target: nil, ranges: &range)
        guard let styleRange = range.first else { return nil }
        let index = self.index(self.startIndex, offsetBy: styleRange.location)
        let collection = Array(style)
        var mutable = self
        mutable.insert(contentsOf: collection, at: index)
        
        return mutable
    }
}

extension NSAttributedString {
    
    func convertHTML() -> String? {
        let newStyle = "br {display: none;}"
        let documentAttributes: [NSAttributedString.DocumentAttributeKey: Any] = [.documentType: NSAttributedString.DocumentType.html]
        do {
            let htmlData = try self.data(from: NSRange(location: 0, length: self.length),
                                         documentAttributes: documentAttributes)
            guard let html = String(data: htmlData, encoding: .utf8) else { return nil }
            let removed = html._removePT()
            return removed.addCSSStyle(style: newStyle)
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
}

// Supporting regular expression
extension String {
    
    func pregMatche(pattern: String, target: NSRange?, options: NSRegularExpression.Options = [], ranges: inout [NSRange]) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return false
        }
        let targetStringRange = target ?? NSRange(location: 0, length: self.count)
        let results = regex.matches(in: self, options: [], range: targetStringRange)
        for i in 0 ..< results.count {
            for j in 0 ..< results[i].numberOfRanges {
                let range = results[i].range(at: j)
                ranges.append(range)
            }
        }
        return !results.isEmpty
    }
    
    func pregReplace(pattern: String, with: String, range: NSRange, options: NSRegularExpression.Options = []) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else { return "" }
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: with)
    }
}
