import Foundation
import MapKit

struct Place {
    
    var title: String
    var latitude: Double
    var longitude: Double
    
    init(entity: PlaceEntity) {
        title = entity.title
        latitude = entity.latitude
        longitude = entity.longitude
    }
}
