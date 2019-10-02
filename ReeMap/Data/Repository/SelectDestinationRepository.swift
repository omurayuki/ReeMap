import CoreLocation
import Foundation
import RxSwift

protocol SelectDestinationRepositoryProtocol {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark>
}

struct SelectDestinationRepository: SelectDestinationRepositoryProtocol {
    
    static let shared = SelectDestinationRepository()
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        let dataStore = LocationDataStoreFactory.createLocationLocalDataStore()
        return dataStore.getPlacemarks(location: location)
    }
}
