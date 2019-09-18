import Foundation

protocol PlaceProtocol {
    
    var title: String { get set }
    var latitude: Double { get set }
    var longitude: Double { get set }
}

extension PlaceEntity: PlaceProtocol {}

struct PlaceEntity: Entity {
    
    var title: String
    var latitude: Double
    var longitude: Double
    
    init(document: [String: Any]) {
        guard
            let title = document["title"] as? String,
            let latitude = document["latitude"] as? Double,
            let longitude = document["longitude"] as? Double
        else {
            self.title = ""
            self.latitude = 0.0
            self.longitude = 0.0
            return
        }
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
    }
}
