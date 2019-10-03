import Foundation

struct User: Model {
    var uid: String
    var displayName: String
    var email: String
    
    init(entity: UserEntity) {
        uid = entity.uid
        displayName = entity.displayName
        email = entity.email
    }
}
