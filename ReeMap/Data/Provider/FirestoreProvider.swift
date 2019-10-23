import Foundation
import FirebaseFirestore
import FirebaseStorage
import RxSwift

struct FirestoreProvider {
    
    func setData(documentRef: DocumentRef, fields: EntityType) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            documentRef.destination.setData(fields, merge: true)
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func updateData(documentRef: DocumentRef, fields: EntityType) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            documentRef.destination.updateData(fields)
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func delete(documentRef: DocumentRef) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            documentRef.destination.delete()
            single(.success(()))
            return Disposables.create()
        })
    }
    
    func get(documentRef: DocumentRef) -> Single<DocumentSnapshot> {
        return Single.create { single in
            documentRef.destination
                .getDocument { snapshot, error in
                    if let error = error {
                        single(.error(error))
                        return
                    }
                    guard let snapshot = snapshot else {
                        single(.error(FirebaseError.unknown))
                        return
                    }
                    single(.success(snapshot))
                }
            return Disposables.create()
        }
    }
    
    func gets(query: QueryRef) -> Single<[QueryDocumentSnapshot]> {
        return Single.create { single in
            query.destination
                .getDocuments { snapshot, error in
                    if let error = error {
                        single(.error(error))
                        return
                    }
                    guard let documents = snapshot?.documents else {
                        single(.error(FirebaseError.unknown))
                        return
                    }
                    single(.success(documents))
                }
            return Disposables.create()
        }
    }
    
    func observe(documentRef: DocumentRef) -> Observable<DocumentSnapshot> {
        return Observable.create { observer in
            documentRef.destination
                .addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
                    if let error = error {
                        observer.on(.error(error))
                        return
                    }
                    guard let snapshot = snapshot else {
                        observer.on(.error(FirebaseError.unknown))
                        return
                    }
                    observer.on(.next(snapshot))
                }
            return Disposables.create()
        }
    }
    
    func observe(query: QueryRef) -> Observable<[QueryDocumentSnapshot]> {
        return Observable.create { observer in
            query.destination
                .addSnapshotListener(includeMetadataChanges: true) { snapshot, error in
                    if let error = error {
                        observer.on(.error(error))
                        return
                    }
                    guard let snapshot = snapshot?.documents else {
                        observer.on(.error(FirebaseError.unknown))
                        return
                    }
                    observer.on(.next(snapshot))
                }
            return Disposables.create()
        }
    }
}
