import Foundation
import MapKit

struct Place: Model {
    
    var uid: String
    var content: String
    var notification: Bool
    var latitude: Double
    var longitude: Double
    var createdAt: Date
    
    init(entity: PlaceEntity) {
        uid = entity.uid
        content = entity.content
        notification = entity.notification
        latitude = entity.latitude
        longitude = entity.longitude
        createdAt = entity.createdAt.dateValue()
    }
}
