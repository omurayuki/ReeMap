import Foundation
import FirebaseFirestore
import FirebaseStorage
import RxSwift

typealias EntityType = [String: Any]

struct FirestoreProvider {
    
    func setData(documentRef: DocumentReference, fields: EntityType) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            documentRef.setData(fields, merge: true, completion: { error in
                if let error = error {
                    single(.error(FirebaseError.resultError(error)))
                    return
                }
                single(.success(()))
            })
            return Disposables.create()
        })
    }
    
    func updateData(documentRef: DocumentReference, fields: EntityType) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            documentRef.updateData(fields, completion: { error in
                if let error = error {
                    single(.error(FirebaseError.resultError(error)))
                    return
                }
                single(.success(()))
            })
            return Disposables.create()
        })
    }
    
    func delete(documentRef: DocumentRef) -> Single<()> {
        return Single.create(subscribe: { single -> Disposable in
            documentRef.destination
                .delete(completion: { error in
                if let error = error {
                    single(.error(FirebaseError.resultError(error)))
                    return
                }
            })
            return Disposables.create()
        })
    }
    
    func get(documentRef: DocumentReference) -> Single<DocumentSnapshot> {
        return Single.create { single in
            documentRef
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
    
    func gets(query: Query) -> Single<[QueryDocumentSnapshot]> {
        return Single.create { single in
            query
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
    
    func observe(documentRef: DocumentReference) -> Observable<DocumentSnapshot> {
        return Observable.create { observer in
            documentRef
                .addSnapshotListener { snapshot, error in
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
    
    func observe(query: Query) -> Observable<[QueryDocumentSnapshot]> {
        return Observable.create { observer in
            query
                .addSnapshotListener { snapshot, error in
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
