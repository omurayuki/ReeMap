import Foundation
import MapKit

protocol Model {}

struct Place: Model {
    
    var title: String
    var latitude: Double
    var longitude: Double
    
    init(entity: PlaceEntity) {
        title = entity.title
        latitude = entity.latitude
        longitude = entity.longitude
    }
}
