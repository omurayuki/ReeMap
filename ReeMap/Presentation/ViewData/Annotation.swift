import Foundation
import MapKit

@objc class Annotation: NSObject {
    
    var content: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(content: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.content = content
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

extension Annotation: MKAnnotation {}
