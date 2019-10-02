import Foundation
import RxSwift

protocol MapRepositoryProtocol {
    
    func AuthenticateAnonymous() -> Single<UserEntity>
    func fetchMemos() -> Observable<[PlaceEntity]>
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
}
