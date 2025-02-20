import Foundation
import MapKit

@objc class Annotation: NSObject {
    
    let clusteringIdentifier = Constants.DictKey.clusteringIdentifier
    
    var documentId: String?
    var content: String?
    var streetAddress: String?
    var notification: Bool?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    var color: UIColor
    
    init(place: Place?, coordinate: CLLocationCoordinate2D, notification: Bool) {
        self.documentId = place?.documentId
        self.content = place?.content
        self.streetAddress = place?.streetAddress
        self.notification = place?.notification
        self.coordinate = coordinate
        self.color = notification ? .annotationDefaultColor : .flatBlue
    }
}

extension Annotation: MKAnnotation {}
