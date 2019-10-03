import Foundation
import RxSwift

protocol AuthRemoteDataStoreProtocol {
    
    func AuthenticateAnonymous() -> Single<UserEntity>
}

struct AuthRemoteDataStore: AuthRemoteDataStoreProtocol {
    
    private let provider = AuthProvider()
    
    func AuthenticateAnonymous() -> Single<UserEntity> {
        return provider.authenticateAnonymous()
    }
}
