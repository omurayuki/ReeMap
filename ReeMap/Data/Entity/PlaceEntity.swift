import FirebaseFirestore
import Foundation

protocol PlaceEntityProtocol {
    
    var uid: String { get set }
    var content: String { get set }
    var notification: Bool { get set }
    var latitude: Double { get set }
    var longitude: Double { get set }
    var createdAt: Timestamp { get set }
}

extension PlaceEntity: PlaceEntityProtocol {}

struct PlaceEntity: Entity {
    
    var documentId: String
    var uid: String
    var content: String
    var notification: Bool
    var streetAddress: String
    var latitude: Double
    var longitude: Double
    var updatedAt: Timestamp
    var createdAt: Timestamp
    
    init(document: [String: Any], documentId: String) {
        guard
            let uid = document["uid"] as? String,
            let title = document["content"] as? String,
            let notification = document["notification"] as? Bool,
            let streetAddress = document["street_addresss"] as? String,
            let geoPoint = document["geo_point"] as? GeoPoint,
            let updatedAt = document["updated_at"] as? Timestamp,
            let createdAt = document["created_at"] as? Timestamp
        else {
            self.documentId = ""
            self.uid = ""
            self.content = ""
            self.notification = false
            self.streetAddress = ""
            self.latitude = 0.0
            self.longitude = 0.0
            self.updatedAt = Timestamp()
            self.createdAt = Timestamp()
            return
        }
        self.documentId = documentId
        self.uid = uid
        self.content = title
        self.notification = notification
        self.streetAddress = streetAddress
        self.latitude = geoPoint.latitude
        self.longitude = geoPoint.longitude
        self.updatedAt = updatedAt
        self.createdAt = createdAt
    }
}
