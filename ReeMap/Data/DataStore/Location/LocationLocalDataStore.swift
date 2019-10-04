import CoreLocation
import Foundation
import MapKit
import RxSwift

protocol LocationLocalDataStoreProtocol {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark>
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark>
    func acquisitionSearchedResult(query: String, location: CLLocation) -> Single<[MKMapItem]>
}

struct LocationLocalDataStore: LocationLocalDataStoreProtocol {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        return Single.create(subscribe: { single -> Disposable in
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                guard let placemark = placemarks?.first else { return }
                if let error = error {
                    single(.error(error))
                    return
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
                    return
                }
                single(.success(placemark))
            }
            return Disposables.create()
        })
    }
    
    func acquisitionSearchedResult(query: String, location: CLLocation) -> Single<[MKMapItem]> {
        return Single.create(subscribe: { single -> Disposable in
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query
            request.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                                               longitude: location.coordinate.longitude),
                                                latitudinalMeters: 1_000,
                                                longitudinalMeters: 1_000)
            MKLocalSearch(request: request).start { response, error in
                if let error = error {
                    single(.error(error))
                    return
                }
                single(.success(response?.mapItems ?? []))
            }
            return Disposables.create()
        })
    }
}
