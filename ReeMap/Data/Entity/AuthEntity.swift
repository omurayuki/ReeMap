import FirebaseAuth

struct UserEntity {
    
    var uid: String
    var displayName: String
    var email: String
    
    init(authData: AuthDataResult) {
        uid = authData.user.uid
        displayName = authData.user.displayName ?? ""
        email = authData.user.email ?? ""
    }
}
