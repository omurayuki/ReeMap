import UIKit

extension UIImage {
    
    // swiftlint:enable:next missing_docs
    // swiftlint:enable:next control_statement
    // swiftlint:enable:next force_unwrapping
    public convenience init?(url: String) {
        if let url = URL(string: url) {
            do {
                let data = try Data(contentsOf: url)
                self.init(data: data)
                return
            } catch let err {
                print("Error : \(err.localizedDescription)")
            }
        }
        self.init()
    }
    
    func fixOrientation() -> UIImage {
        if (imageOrientation == .up) { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func scale(to newSize: CGSize) -> UIImage? {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func savedPhotosAlbum() {
        let imageData = pngData()
        guard let saveImage = UIImage(data: imageData ?? Data()) else { return }
        UIImageWriteToSavedPhotosAlbum(saveImage, self, nil, nil)
    }
}
