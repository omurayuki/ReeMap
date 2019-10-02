import CoreLocation
import Foundation
import RxSwift

protocol NoteListRepositoryProtocol {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark>
}

struct NoteListRepository: NoteListRepositoryProtocol {
    
    static let shared = NoteListRepository()
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        let dataStore = LocationDataStoreFactory.createLocationLocalDataStore()
        return dataStore.getPlacemarks(location: location)
    }
}
