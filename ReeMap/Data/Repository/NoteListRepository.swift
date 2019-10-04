import CoreLocation
import Foundation
import RxSwift

protocol NoteListRepositoryProtocol {
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark>
    func deleteNote(place: Place) -> Single<()>
}

struct NoteListRepository: NoteListRepositoryProtocol {
    
    static let shared = NoteListRepository()
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        let dataStore = LocationDataStoreFactory.createLocationLocalDataStore()
        return dataStore.getPlacemarks(location: location)
    }
    
    func deleteNote(place: Place) -> Single<()> {
        let dataStore = NoteDataStoreFactory.createNoteRemoteDataStore()
        return dataStore.deleteNote(place: place)
    }
}
