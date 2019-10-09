import Foundation
import MapKit

struct Place: Model {
    
    var documentId: String
    var uid: String
    var content: String
    var notification: Bool
    var streetAddress: String
    var latitude: Double
    var longitude: Double
    var createdAt: Date
    
    init(entity: PlaceEntity) {
        documentId = entity.documentId
        uid = entity.uid
        content = entity.content
        notification = entity.notification
        streetAddress = entity.streetAddress
        latitude = entity.latitude
        longitude = entity.longitude
        createdAt = entity.createdAt.dateValue()
    }
}
