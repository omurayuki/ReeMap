import FirebaseFirestore
import Foundation
import RxSwift

protocol MapRemoteDataStoreProtocol {
    
    func fetchMemos() -> Observable<[PlaceEntity]>
}

struct MapRemoteDataStore: MapRemoteDataStoreProtocol {
    
    private let provider = FirestoreProvider()
    
    func fetchMemos() -> Observable<[PlaceEntity]> {
        return provider.observe(query: Firestore.firestore().user)
            .flatMapLatest({ entity -> Observable<[PlaceEntity]> in
                Observable.of(entity.compactMap { PlaceEntity(document: $0.data()) })
            }).share(replay: 1)
    }
}
