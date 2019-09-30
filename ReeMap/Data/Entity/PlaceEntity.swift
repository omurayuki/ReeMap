import Foundation

protocol PlaceEntityProtocol {
    
    var content: String { get set }
    var latitude: Double { get set }
    var longitude: Double { get set }
}

extension PlaceEntity: PlaceEntityProtocol {}

struct PlaceEntity: Entity {
    
    var content: String
    var latitude: Double
    var longitude: Double
    
    init(document: [String: Any]) {
        guard
            let title = document["content"] as? String,
            let latitude = document["latitude"] as? Double,
            let longitude = document["longitude"] as? Double
        else {
            self.content = ""
            self.latitude = 0.0
            self.longitude = 0.0
            return
        }
        self.content = title
        self.latitude = latitude
        self.longitude = longitude
    }
}
