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
    var updatedAt: Date
    var createdAt: Date
    
    init(entity: PlaceEntity) {
        documentId = entity.documentId
        uid = entity.uid
        content = entity.content
        notification = entity.notification
        streetAddress = entity.streetAddress
        latitude = entity.latitude
        longitude = entity.longitude
        updatedAt = entity.updatedAt.dateValue()
        createdAt = entity.createdAt.dateValue()
    }
}
