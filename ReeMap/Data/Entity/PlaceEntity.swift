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
    
    var uid: String
    var content: String
    var notification: Bool
    var latitude: Double
    var longitude: Double
    var createdAt: Timestamp
    
    init(document: [String: Any]) {
        guard
            let uid = document["uid"] as? String,
            let title = document["content"] as? String,
            let notification = document["notification"] as? Bool,
            let geoPoint = document["geo_point"] as? GeoPoint,
            let createdAt = document["created_at"] as? Timestamp
        else {
            self.uid = ""
            self.content = ""
            self.notification = false
            self.latitude = 0.0
            self.longitude = 0.0
            self.createdAt = Timestamp()
            return
        }
        self.uid = uid
        self.content = title
        self.notification = notification
        self.latitude = geoPoint.latitude
        self.longitude = geoPoint.longitude
        self.createdAt = createdAt
    }
}
