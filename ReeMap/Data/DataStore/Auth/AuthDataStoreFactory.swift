import Foundation

struct AuthDataStoreFactory {
    
    static func createAuthRemoteDataStore() -> AuthRemoteDataStoreProtocol {
        return AuthRemoteDataStore()
    }
    
    static func createAuthLocalDataStore() -> AuthLocalDataStoreProtocol {
        return AuthLocalDataStore()
    }
}
