import CoreLocation
import Foundation
import RxSwift

protocol SelectDestinationLocalDataStoreProtocol {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark>
}

struct SelectDestinationLocalDataStore: SelectDestinationLocalDataStoreProtocol {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        return Single.create(subscribe: { single -> Disposable in
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                guard let placemark = placemarks?.first else { return }
                if let error = error {
                    single(.error(error))
                }
                single(.success(placemark))
            }
            return Disposables.create()
        })
    }
}
