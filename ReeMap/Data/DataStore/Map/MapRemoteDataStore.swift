import Foundation
import RxSwift

protocol MapRemoteDataStoreProtocol {
    
    func fetchMemos() -> Observable<[PlaceEntity]>
}

struct MapRemoteDataStore: MapRemoteDataStoreProtocol {
    
    func fetchMemos() -> Observable<[PlaceEntity]> {
        return Observable.create({ observer -> Disposable in
            let array = [
                ["content": "hogeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeereeeeeeeeeeeeeeeeeeee", "latitude": 35.658581, "longitude": 139.745433],
                ["content": "fuga", "latitude": 35.660238, "longitude": 139.730077]
            ]
            let places = array.compactMap { PlaceEntity(document: $0) }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                observer.on(.next(places))
            })
            return Disposables.create()
        })
    }
}
