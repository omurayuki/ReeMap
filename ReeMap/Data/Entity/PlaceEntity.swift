import Foundation

protocol Place {
    
    var title: String { get set }
    var latitude: Double { get set }
    var longtitude: Double { get set }
}

extension PlaceEntity: Place {}

struct PlaceEntity: Entity {
    
    var title: String
    var latitude: Double
    var longtitude: Double
    
    init(document: [String: Any]) {
        guard
            let title = document["title"] as? String,
            let latitude = document["latitude"] as? Double,
            let longitude = document["longitude"] as? Double
        else {
            self.title = ""
            self.latitude = 0.0
            self.longtitude = 0.0
            return
        }
        self.title = title
        self.latitude = latitude
        self.longtitude = longitude
    }
}
