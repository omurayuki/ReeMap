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
            let uid = document[Constants.DictKey.uid] as? String,
            let title = document[Constants.DictKey.content] as? String,
            let notification = document[Constants.DictKey.notification] as? Bool,
            let streetAddress = document[Constants.DictKey.streetAddress] as? String,
            let geoPoint = document[Constants.DictKey.geoPoint] as? GeoPoint
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
        // MARK: Attension
        // Timestamp.servertimeで現在時刻取得を取得しているが、おそらくネットワーク介しての取得なので、オフラインの時に取得できずNullになる
        // なのでオフライン時にキャッシュからデータを取得しようとすると、created_at and updated_atがnullなので、guard letで弾かれてからのデータが入ってしまう
        // それを回避したいので、一旦下記のように設定
        let updatedAt = document[Constants.DictKey.updatedAt] as? Timestamp ?? Timestamp()
        let createdAt = document[Constants.DictKey.createdAt] as? Timestamp ?? Timestamp()
        
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
