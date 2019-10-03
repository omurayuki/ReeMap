import Foundation
import MapKit

@objc class Annotation: NSObject {
    
    var content: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(content: String?, coordinate: CLLocationCoordinate2D) {
        self.content = content
        self.coordinate = coordinate
    }
}

extension Annotation: MKAnnotation {}
