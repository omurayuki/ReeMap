import Foundation
import MapKit

@objc class Annotation: NSObject {
    
    var uid: String?
    var content: String?
    var streetAddress: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(place: Place?, coordinate: CLLocationCoordinate2D) {
        self.uid = place?.uid
        self.content = place?.content
        self.streetAddress = place?.streetAddress
        self.coordinate = coordinate
    }
}

extension Annotation: MKAnnotation {}
