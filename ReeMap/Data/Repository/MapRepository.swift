import Foundation
import RxSwift

protocol MapRepositoryProtocol {
    
    func AuthenticateAnonymous() -> Single<UserEntity>
    func fetchMemos() -> Observable<[PlaceEntity]>
    func getUIDToken() -> Single<String>
    func setUIDToken(_ token: String)
}

struct MapRepository: MapRepositoryProtocol {
    
    static let shared = MapRepository()
    
    func AuthenticateAnonymous() -> Single<UserEntity> {
        let dataStore = AuthDataStoreFactory.createAuthRemoteDataStore()
        return dataStore.AuthenticateAnonymous()
    }
    
    func fetchMemos() -> Observable<[PlaceEntity]> {
        let dataStore = MapDataStoreFactory.createMapRemoteDataStore()
        return dataStore.fetchMemos()
    }
    
    func getUIDToken() -> Single<String> {
        let dataStore = AuthDataStoreFactory.createAuthLocalDataStore()
        return dataStore.getUIDToken()
    }
    
    func setUIDToken(_ token: String) {
        let dataStore = AuthDataStoreFactory.createAuthLocalDataStore()
        return dataStore.setUIDToken(token)
    }
}
