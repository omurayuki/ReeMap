import Foundation

struct AuthTranslator {
    
    func translate(_ entitiy: UserEntity) -> User {
        return User(entity: entitiy)
    }
}
