import CoreLocation
import Foundation
import RxSwift

protocol CreateMemoRepositoryProtocol {
    
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark>
    func setNote(_ note: EntityType) -> Single<()>
    func getUIDToken() -> String
}

struct CreateMemoRepository: CreateMemoRepositoryProtocol {
    
    static let shared = CreateMemoRepository()
    
    func getPlacemarks(streetAddress: String) -> Single<CLPlacemark> {
        let dataStore = LocationDataStoreFactory.createLocationLocalDataStore()
        return dataStore.getPlacemarks(streetAddress: streetAddress)
    }
    
    func setNote(_ note: EntityType) -> Single<()> {
        let dataStore = NoteDataStoreFactory.createNoteRemoteDataStore()
        return dataStore.setNote(note)
    }
    
    func getUIDToken() -> String {
        let dataStore = AuthDataStoreFactory.createAuthLocalDataStore()
        return dataStore.getUIDToken()
    }
}
