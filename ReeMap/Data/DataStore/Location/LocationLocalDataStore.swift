import CoreLocation
import Foundation
import RxSwift

protocol LocationLocalDataStoreProtocol {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark>
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark>
}

struct LocationLocalDataStore: LocationLocalDataStoreProtocol {
    
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
    
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark> {
        return Single.create(subscribe: { single -> Disposable in
            CLGeocoder().geocodeAddressString(streetAddress) { placemarks, error in
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
