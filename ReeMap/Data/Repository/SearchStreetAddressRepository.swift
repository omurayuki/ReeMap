import CoreLocation
import Foundation
import MapKit
import RxSwift

protocol SearchStreetAddressRepositoryProtocol {
    
    func acquisitionSearchedResult(query: String, location: CLLocation) -> Single<[MKMapItem]>
}

struct SearchStreetAddressRepository: SearchStreetAddressRepositoryProtocol {
    
    static let shared = SearchStreetAddressRepository()
    
    func acquisitionSearchedResult(query: String, location: CLLocation) -> Single<[MKMapItem]> {
        let dataStore = LocationDataStoreFactory.createLocationLocalDataStore()
        return dataStore.acquisitionSearchedResult(query: query, location: location)
    }
}
