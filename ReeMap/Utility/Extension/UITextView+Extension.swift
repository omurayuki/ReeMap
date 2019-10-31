import UIKit

extension UITextView {
    
    func addImage(image: UIImage) {
        let attachment = NSTextAttachment()
        
        guard let cgImage = image.cgImage else { return }
        
        attachment.image = UIImage(cgImage: cgImage, scale: 10, orientation: UIImage.Orientation.up)
        
        let attributedString = NSAttributedString(attachment: attachment)
        
        let currentMutable = NSMutableAttributedString(attributedString: self.attributedText)
        currentMutable.append(attributedString)
        
        self.attributedText = currentMutable
    }
    
    func getImages() -> [UIImage] {
        var images = [UIImage]()
        let attributedString = self.attributedText
        
        attributedString?.enumerateAttribute(NSAttributedString.Key.attachment,
                                             in: NSRange(location: 0, length: attributedString?.length ?? Int(0.0)),
                                             options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (value, range, _) in
            guard let attachment = value as? NSTextAttachment else { return }
            
            if let image = attachment.image {
                images.append(image)
            } else if let image = attachment.image(forBounds: attachment.bounds, textContainer: nil, characterIndex: range.location) {
                images.append(image)
            }
        }
        return images
    }
    
    // 文字列とimage全て取得
    func getParts() -> [AnyObject] {
        var parts = [AnyObject]()

        let attributedString = self.attributedText
        let range = NSRange(location: 0, length: attributedString?.length ?? 0)
        attributedString?.enumerateAttributes(in: range,
                                              options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (object, range, _) in
            if object.keys.contains(NSAttributedString.Key.attachment) {
                if let attachment = object[NSAttributedString.Key.attachment] as? NSTextAttachment {
                    if let image = attachment.image {
                        parts.append(image)
                    } else if let image = attachment.image(forBounds: attachment.bounds,
                                                           textContainer: nil,
                                                           characterIndex: range.location) {
                        parts.append(image)
                    }
                }
            } else {
                let stringValue: String = attributedString?.attributedSubstring(from: range).string ?? ""
                if !stringValue.trimmingCharacters(in: .whitespaces).isEmpty {
                    parts.append(stringValue as AnyObject)
                }
            }
        }
        return parts
    }
}
