import CoreLocation
import FirebaseFirestore
import Foundation
import RxSwift

protocol NoteRemoteDataStoreProtocol {
    
    func fetchNotes() -> Observable<[PlaceEntity]>
    func setNote(_ note: EntityType) -> Single<()>
    func updateNote(_ note: EntityType, noteId: String) -> Single<()>
    func deleteNote(place: Place) -> Single<()>
}

struct NoteRemoteDataStore: NoteRemoteDataStoreProtocol {
    
    private let provider = FirestoreProvider()
    
    func fetchNotes() -> Observable<[PlaceEntity]> {
        return provider.observe(query: .user)
            .flatMapLatest({ entity -> Observable<[PlaceEntity]> in
                Observable.of(entity.compactMap { PlaceEntity(document: $0.data(),
                                                              documentId: $0.documentID) })
            }).share(replay: 1)
    }
    
    func setNote(_ note: EntityType) -> Single<()> {
        return provider.setData(documentRef: .setNote, fields: note)
    }
    
    func updateNote(_ note: EntityType, noteId: String) -> Single<()> {
        return provider.updateData(documentRef: .updateNote(id: noteId), fields: note)
    }
    
    func deleteNote(place: Place) -> Single<()> {
        return provider.delete(documentRef: .deleteNote(id: place.documentId))
    }
}
