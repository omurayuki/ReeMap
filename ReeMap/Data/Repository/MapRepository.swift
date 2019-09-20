import Foundation
import RxSwift

protocol MapRepositoryProtocol {
    
    func fetchMemos() -> Observable<[PlaceEntity]>
}

struct MapRepository: MapRepositoryProtocol {
    
    static let shared = MapRepository()
    
    func fetchMemos() -> Observable<[PlaceEntity]> {
        let dataStore = MapDataStoreFactory.createMapRemoteDataStore()
        return dataStore.fetchMemos()
    }
}
