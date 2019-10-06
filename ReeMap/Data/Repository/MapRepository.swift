import CoreLocation
import Foundation
import RxSwift

protocol MapRepositoryProtocol {
    
    func AuthenticateAnonymous() -> Single<UserEntity>
    func fetchNotes() -> Observable<[PlaceEntity]>
    func updateNote(_ note: EntityType, noteId: String) -> Single<()>
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark>
    func getUIDToken() -> String
    func setUIDToken(_ token: String)
}

struct MapRepository: MapRepositoryProtocol {
    
    static let shared = MapRepository()
    
    func AuthenticateAnonymous() -> Single<UserEntity> {
        let dataStore = AuthDataStoreFactory.createAuthRemoteDataStore()
        return dataStore.AuthenticateAnonymous()
    }
    
    func fetchNotes() -> Observable<[PlaceEntity]> {
        let dataStore = NoteDataStoreFactory.createNoteRemoteDataStore()
        return dataStore.fetchNotes()
    }
    
    func updateNote(_ note: EntityType, noteId: String) -> Single<()> {
        let dataStore = NoteDataStoreFactory.createNoteRemoteDataStore()
        return dataStore.updateNote(note, noteId: noteId)
    }
    
    func getPlacemarks(location: CLLocation) -> Single<CLPlacemark> {
        let dataStore = LocationDataStoreFactory.createLocationLocalDataStore()
        return dataStore.getPlacemarks(location: location)
    }
    
    func getUIDToken() -> String {
        let dataStore = AuthDataStoreFactory.createAuthLocalDataStore()
        return dataStore.getUIDToken()
    }
    
    func setUIDToken(_ token: String) {
        let dataStore = AuthDataStoreFactory.createAuthLocalDataStore()
        return dataStore.setUIDToken(token)
    }
}
