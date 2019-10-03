import CoreLocation
import FirebaseFirestore
import Foundation
import RxSwift

protocol NoteRemoteDataStoreProtocol {
    
    func fetchNotes() -> Observable<[PlaceEntity]>
    func setNote(_ note: EntityType) -> Single<()>
}

struct NoteRemoteDataStore: NoteRemoteDataStoreProtocol {
    
    private let provider = FirestoreProvider()
    
    func fetchNotes() -> Observable<[PlaceEntity]> {
        return provider.observe(query: Firestore.firestore().user)
            .flatMapLatest({ entity -> Observable<[PlaceEntity]> in
                Observable.of(entity.compactMap { PlaceEntity(document: $0.data()) })
            }).share(replay: 1)
    }
    
    func setNote(_ note: EntityType) -> Single<()> {
        return provider.setData(documentRef: Firestore.firestore().note, fields: note)
    }
}
