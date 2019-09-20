import Foundation
import RxSwift

protocol MapRemoteDataStoreProtocol {
    
    func fetchMemos() -> Observable<[PlaceEntity]>
}

struct MapRemoteDataStore: MapRemoteDataStoreProtocol {
    
    func fetchMemos() -> Observable<[PlaceEntity]> {
        return Observable.create({ observer -> Disposable in
            observer.on(.next([PlaceEntity]()))
            return Disposables.create()
        })
    }
}
