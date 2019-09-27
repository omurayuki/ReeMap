import Foundation
import MapKit

protocol Model {}

struct Place: Model {
    
    var content: String
    var latitude: Double
    var longitude: Double
    
    init(entity: PlaceEntity) {
        content = entity.content
        latitude = entity.latitude
        longitude = entity.longitude
    }
}
