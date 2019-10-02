import CoreLocation
import Foundation
import RxSwift

protocol NoteListRepositoryProtocol {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark>
}

struct NoteListRepository: NoteListRepositoryProtocol {
    
    static let shared = NoteListRepository()
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        let dataStore = SelectDestinationDataStoreFactory.createSelectDestinationLocalDataStore()
        return dataStore.getPlacemarks(location: location)
    }
}
